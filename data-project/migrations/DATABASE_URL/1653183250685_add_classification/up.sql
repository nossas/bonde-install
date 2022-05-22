SET check_function_bodies = false;
CREATE TYPE public.change_password_fields AS (
	user_first_name text,
	user_last_name text,
	token postgraphql.jwt_token
);
CREATE TYPE public.dnshostedzonestatus AS ENUM (
    'created',
    'propagating',
    'propagated',
    'certifying',
    'certified'
);
CREATE DOMAIN public.email AS public.citext
	CONSTRAINT email_check CHECK ((VALUE OPERATOR(public.~) '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::public.citext));
CREATE TYPE public.status_mobilization AS ENUM (
    'active',
    'archived'
);
CREATE FUNCTION public.locale_names() RETURNS text[]
    LANGUAGE sql IMMUTABLE
    AS $$
    select '{pt-BR, es, en}'::text[];
$$;
CREATE TABLE public.users (
    id integer NOT NULL,
    provider character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    first_name character varying,
    last_name character varying,
    email character varying,
    tokens text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    avatar character varying,
    admin boolean,
    locale text DEFAULT 'pt-BR'::text NOT NULL,
    is_admin boolean DEFAULT false,
    CONSTRAINT localechk CHECK ((locale = ANY (public.locale_names())))
);
CREATE TABLE public.twilio_calls (
    id integer NOT NULL,
    activist_id integer,
    widget_id integer,
    twilio_account_sid text,
    twilio_call_sid text,
    "from" text NOT NULL,
    "to" text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    community_id integer
);
CREATE TABLE public.twilio_configurations (
    id integer NOT NULL,
    community_id integer NOT NULL,
    twilio_account_sid text NOT NULL,
    twilio_auth_token text NOT NULL,
    twilio_number text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE TABLE public.invitations (
    id integer NOT NULL,
    community_id integer,
    user_id integer,
    email character varying,
    code character varying,
    expires timestamp without time zone,
    role integer,
    expired boolean,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.facebook_bot_campaigns (
    id integer NOT NULL,
    facebook_bot_configuration_id integer NOT NULL,
    name text NOT NULL,
    segment_filters jsonb NOT NULL,
    total_impacted_activists integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE TABLE public.template_mobilizations (
    id integer NOT NULL,
    name character varying,
    user_id integer,
    color_scheme character varying,
    facebook_share_title character varying,
    facebook_share_description text,
    header_font character varying,
    body_font character varying,
    facebook_share_image character varying,
    slug character varying,
    custom_domain character varying,
    twitter_share_text character varying(140),
    community_id integer,
    uses_number integer,
    global boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    goal text,
    favicon character varying
);
CREATE TABLE public.activist_tags (
    id integer NOT NULL,
    activist_id integer,
    community_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mobilization_id integer
);
CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying,
    tagger_id integer,
    tagger_type character varying,
    context character varying(128),
    created_at timestamp without time zone
);
CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0,
    label text,
    kind text
);
CREATE VIEW public.community_tags AS
 SELECT at.community_id,
    tag.name AS tag_complete_name,
    (regexp_split_to_array((tag.name)::text, '_'::text))[1] AS tag_from,
    (regexp_split_to_array((tag.name)::text, '_'::text))[2] AS tag_name,
    count(DISTINCT at.activist_id) AS total_activists,
    tag.label AS tag_label
   FROM ((public.activist_tags at
     JOIN public.taggings tgs ON ((((tgs.taggable_type)::text = 'ActivistTag'::text) AND (tgs.taggable_id = at.id))))
     JOIN public.tags tag ON ((tag.id = tgs.tag_id)))
  GROUP BY at.community_id, tag.name, tag.label;
CREATE TABLE public.activists (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying,
    document_number character varying,
    document_type character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    city character varying,
    first_name text,
    last_name text,
    state text
);
CREATE TABLE public.community_activists (
    id integer NOT NULL,
    community_id integer NOT NULL,
    activist_id integer NOT NULL,
    search_index tsvector,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_data jsonb
);
CREATE TABLE public.community_users (
    id integer NOT NULL,
    user_id integer,
    community_id integer,
    role integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.facebook_bot_campaign_activists (
    id integer NOT NULL,
    facebook_bot_campaign_id integer NOT NULL,
    facebook_bot_activist_id integer NOT NULL,
    received boolean DEFAULT false NOT NULL,
    log jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE FUNCTION public.configuration(name text) RETURNS text
    LANGUAGE sql
    AS $_$
            select value from public.configurations where name = $1;
        $_$;
CREATE FUNCTION public.copy_activist_pressures() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO
        activist_actions(action, widget_id, mobilization_id, community_id, activist_id, action_created_at, activist_created_at)
    SELECT 'activist_pressures'::text AS action,
		w.id AS widget_id,
		m.id AS mobilization_id,
		m.community_id,
		fe.activist_id,
		fe.created_at AS action_created_date,
		a.created_at AS activist_created_at
	FROM activist_pressures fe
		 JOIN activists a ON a.id = fe.activist_id
		 JOIN widgets w ON w.id = fe.widget_id
		 JOIN blocks b ON b.id = w.block_id
		 JOIN mobilizations m ON m.id = b.mobilization_id
	WHERE fe.id = new.id;
   	RETURN new;
END;
$$;
CREATE FUNCTION public.copy_donations() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO
        activist_actions(action, widget_id, mobilization_id, community_id, activist_id, action_created_at, activist_created_at)
    SELECT 'donations'::text AS action,
		w.id AS widget_id,
		m.id AS mobilization_id,
		m.community_id,
		fe.activist_id,
		fe.created_at AS action_created_date,
		a.created_at AS activist_created_at
	FROM donations fe
		 JOIN activists a ON a.id = fe.activist_id
		 JOIN widgets w ON w.id = fe.widget_id
		 JOIN blocks b ON b.id = w.block_id
		 JOIN mobilizations m ON m.id = b.mobilization_id
	WHERE fe.id = new.id;
   	RETURN new;
END;
$$;
CREATE FUNCTION public.copy_form_entries() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO
        activist_actions(action, widget_id, mobilization_id, community_id, activist_id, action_created_at, activist_created_at)
    SELECT 'form_entries'::text AS action,
		w.id AS widget_id,
		m.id AS mobilization_id,
		m.community_id,
		fe.activist_id,
		fe.created_at AS action_created_date,
		a.created_at AS activist_created_at
	FROM form_entries fe
		 JOIN activists a ON a.id = fe.activist_id
		 JOIN widgets w ON w.id = fe.widget_id
		 JOIN blocks b ON b.id = w.block_id
		 JOIN mobilizations m ON m.id = b.mobilization_id
	WHERE fe.id = new.id;
   	RETURN new;
END;
$$;
CREATE FUNCTION public.diesel_manage_updated_at(_tbl regclass) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %s
                    FOR EACH ROW EXECUTE PROCEDURE diesel_set_updated_at()', _tbl);
END;
$$;
CREATE FUNCTION public.diesel_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (
        NEW IS DISTINCT FROM OLD AND
        NEW.updated_at IS NOT DISTINCT FROM OLD.updated_at
    ) THEN
        NEW.updated_at := current_timestamp;
    END IF;
    RETURN NEW;
END;
$$;
CREATE FUNCTION public.facebook_activist_message_full_text_index(v_message text) RETURNS tsvector
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN setweight(to_tsvector('portuguese', v_message), 'A');
    END;
$$;
CREATE TABLE public.form_entries (
    id integer NOT NULL,
    widget_id integer,
    fields text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    synchronized boolean,
    activist_id integer,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    cached_community_id integer,
    rede_syncronized boolean DEFAULT false,
    mobilization_id integer,
    mailchimp_status character varying(20)
);
CREATE FUNCTION public.first_time_in_entries(entry public.form_entries) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
        select (select
            count(1)
        from form_entries fe2
        where 
            entry.activist_id = fe2.activist_id 
            and fe2.created_at <= entry.created_at
            and entry.id <> fe2.id
            limit 2) > 1;
    $$;
CREATE TABLE public.activist_pressures (
    id integer NOT NULL,
    activist_id integer,
    widget_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    cached_community_id integer,
    mobilization_id integer,
    targets jsonb,
    syncronized boolean,
    form_data jsonb,
    status text DEFAULT 'draft'::text,
    mailchimp_status character varying(20)
);
CREATE FUNCTION public.first_time_in_pressures(pressure public.activist_pressures) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
        select (select
            count(1)
        from activist_pressures ap2
        where 
            pressure.activist_id = ap2.activist_id 
            and ap2.created_at <= pressure.created_at
            and ap2.id <> pressure.id
            limit 2) > 1;
    $$;
CREATE FUNCTION public.generate_activists_from_generic_resource_with_widget() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        declare
            v_mobilization public.mobilizations;
            v_profile_data json;
        begin
            IF TG_TABLE_NAME in ('subscriptions', 'form_entries', 'donations', 'activist_pressures')
                AND NEW.activist_id is not null AND NEW.widget_id is not null THEN
                select distinct(m.*) from mobilizations m
                    join blocks b on b.mobilization_id = m.id
                    join widgets w on w.block_id = b.id
                    where w.id = NEW.widget_id
                    into v_mobilization;
                select row_to_json(activists.*) from activists where id = NEW.activist_id
                    into v_profile_data;
                IF v_mobilization.id IS NOT NULL THEN
                    if not exists(select true
                        from community_activists
                        where community_id = v_mobilization.community_id and activist_id = NEW.activist_id) then
                        insert into community_activists (community_id, activist_id, created_at, updated_at, profile_data)
                            values (v_mobilization.community_id, NEW.activist_id, now(), now(), v_profile_data::jsonb);
                    end if;
                    if not exists(select true
                        from mobilization_activists
                        where mobilization_id = v_mobilization.id and activist_id = NEW.activist_id) then
                        insert into mobilization_activists (mobilization_id, activist_id, created_at, updated_at)
                            values (v_mobilization.id, NEW.activist_id, now(), now());
                    end if;
                END IF;
            END IF;
            return NEW;
        end;
    $$;
CREATE FUNCTION public.generate_notification_tags(relations json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
    declare
        _subscription public.subscriptions;
        _donation public.donations;
        _last_subscription_payment public.donations;
        _activist public.activists;
        _community public.communities;
        _mobilization public.mobilizations;
        _user public.users;
        _result json;
    begin
        -- get subscription when json->>'subscription_id' is present
        select * from public.subscriptions where id = ($1->>'subscription_id')::integer
            into _subscription;
        -- get donation when json->>'donation_id' is present
        select * from public.donations where id = ($1->>'donation_id')::integer
            into _donation;
        -- get last subscription donation when json ->> 'subscription_id' is present
        select * from public.donations where local_subscription_id = _subscription.id
            order by created_at desc limit 1 into _last_subscription_payment;
        -- get activist when json ->> 'activist_id' is present or subscription/donation is found
        select * from public.activists where id = coalesce(coalesce(($1->>'activist_id')::integer, _subscription.activist_id), _donation.activist_id)
            into _activist;
        -- get community when json->>'community_id' is present or subscription/donation is found
        select * from public.communities where id = coalesce(coalesce(($1->>'community_id')::integer, _subscription.community_id), _donation.cached_community_id)
            into _community;
        -- get user when json->>'user_id' is present
        select * from public.users where id = ($1->>'user_id')::integer 
            into _user;
        -- get mobilization from subscription/donation widget when block is defined
        select * from mobilizations m
            join blocks b on b.mobilization_id = m.id
            join widgets w on w.block_id = b.id
            where w.id = coalesce(_subscription.widget_id, _donation.widget_id)
            into _mobilization;
        -- build and return template tags json after collect all data
        _result := json_build_object(
            'subscription_id', _subscription.id,
            'payment_method', coalesce(_subscription.payment_method, _donation.payment_method),
            'donation_id', _donation.id,
            'widget_id', _donation.widget_id,
            'mobilization_id', _mobilization.id,
            'mobilization_name', _mobilization.name,
            'boleto_expiration_date', (_donation.gateway_data ->> 'boleto_expiration_date'),
            'boleto_barcode', (_donation.gateway_data ->> 'boleto_barcode'),
            'boleto_url', (_donation.gateway_data ->> 'boleto_url'),
            'manage_url', (
                case when _subscription.id is not null then
                    'https://minhadoacao.bonde.org/subscriptions/'||_subscription.id||'/edit?token='||_subscription.token
                else null end
            ),
            'amount', (coalesce(_subscription.amount, _donation.amount) / 100),
            'user', json_build_object(
                'first_name', _user.first_name,
                'last_name', _user.last_name
            ),
            'customer', json_build_object(
                'name', _activist.name,
                'first_name', _activist.first_name,
                'last_name', _activist.last_name
            ),
            'community', json_build_object(
                'id', _community.id,
                'name', _community.name,
                'image', _community.image
            ),
            'last_donation', json_build_object(
                'payment_method', _last_subscription_payment.payment_method,
                'widget_id', _last_subscription_payment.widget_id,
                'mobilization_id', _mobilization.id,
                'mobilization_name', _mobilization.name,
                'boleto_expiration_date', (_last_subscription_payment.gateway_data ->> 'boleto_expiration_date'),
                'boleto_barcode', (_last_subscription_payment.gateway_data ->> 'boleto_barcode'),
                'boleto_url', (_last_subscription_payment.gateway_data ->> 'boleto_url')
            )
        );
        return _result;
    end;
$_$;
CREATE FUNCTION public.get_current_user(hasura_session json) RETURNS SETOF public.users
    LANGUAGE sql STABLE
    AS $$
  select * from users where id = (hasura_session ->> 'x-hasura-user-id')::Int
$$;
CREATE TABLE public.widget_donation_stats (
    widget_id integer,
    stats json
);
CREATE FUNCTION public.get_widget_donation_stats(widget_id integer) RETURNS SETOF public.widget_donation_stats
    LANGUAGE sql STABLE
    AS $_$
    select
        w.id as widget_id,
        json_build_object(
        'pledged', sum(d.amount / 100) + coalesce(nullif(w.settings::json->>'external_resource', ''), '0')::bigint,
        'widget_id', w.id,
        'goal', w.goal,
        'progress', ((sum(d.amount / 100) + coalesce(nullif(w.settings::json->>'external_resource', ''), '0')::bigint) / w.goal) * 100,
        'total_donations', (count(distinct d.id)),
        'total_donators', (count(distinct d.activist_id))
        ) as stats
    from widgets w
        join donations d on d.widget_id = w.id
        where w.id = $1 and
            d.transaction_status = 'paid'
        group by w.id;
$_$;
CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    widget_id integer,
    activist_id integer,
    community_id integer,
    card_data jsonb,
    status character varying,
    period integer DEFAULT 30,
    amount integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    payment_method text NOT NULL,
    token uuid DEFAULT public.uuid_generate_v4(),
    gateway_subscription_id integer,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    gateway_customer_id integer,
    customer_data jsonb,
    schedule_next_charge_at timestamp without time zone
);
CREATE FUNCTION public.next_transaction_charge_date(public.subscriptions) RETURNS timestamp without time zone
    LANGUAGE sql STABLE
    AS $_$
        select
            d.created_at + '1 month'::interval
        from public.donations d 
            where d.transaction_status = 'paid'
                and d.local_subscription_id = $1.id
            order by d.created_at desc limit 1;
    $_$;
CREATE FUNCTION public.nossas_recipient_id() RETURNS text
    LANGUAGE sql
    AS $$
         select 're_cinemdtb204bk2l5x8zri0iv8'::text;
$$;
CREATE FUNCTION public.notify(template_name text, relations json) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
    declare
        _community public.communities;
        _user public.users;
        _activist public.activists;
        _notification public.notifications;
        _notification_template public.notification_templates;
        _template_vars json;
    begin
        -- get community from relations
        select * from public.communities where id = ($2->>'community_id')::integer
            into _community;
        -- get user from relations
        select * from public.users where id = ($2->>'user_id')::integer
            into _user;
        -- get activist when set on relations
        select * from public.activists where id = ($2->>'activist_id')::integer
            into _activist;
        -- try get notification template from community
        select * from public.notification_templates nt
            where nt.community_id = ($2->>'community_id')::integer
                and nt.label = $1
            into _notification_template;
        -- if not found on community try get without community
        if _notification_template is null then
            select * from public.notification_templates nt
                where nt.label = $1
                into _notification_template;
            if _notification_template is null then
                raise 'invalid_notification_template';
            end if;
        end if;
        _template_vars := public.generate_notification_tags(relations);
        -- insert notification to database
        insert into notifications(activist_id, notification_template_id, template_vars, created_at, updated_at, user_id, email)
            values (_activist.id, _notification_template.id, _template_vars::jsonb, now(), now(), _user.id, $2->>'email')
        returning * into _notification;
        -- notify to notification_channels
        perform pg_notify('notifications_channel',pgjwt.sign(json_build_object(
            'action', 'deliver_notification',
            'id', _notification.id,
            'created_at', now(),
            'sent_to_queuing', now(),
            'jit', now()::timestamp
        ), public.configuration('jwt_secret'), 'HS512'));
        return json_build_object('id', _notification.id);
    end;
$_$;
CREATE FUNCTION public.notify_create_twilio_configuration_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'INSERT') THEN
            perform pg_notify('twilio_configuration_created', row_to_json(NEW)::text);
          END IF;
          IF (TG_OP = 'UPDATE') THEN
            perform pg_notify('twilio_configuration_updated', row_to_json(NEW)::text);
          END IF;
          RETURN NEW;
        END;
      $$;
CREATE FUNCTION public.notify_form_entries_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          perform pg_notify('form_entries_channel',
            pgjwt.sign(
              row_to_json(NEW),
              public.configuration('jwt_secret'),
              'HS512'
            )
          );
          RETURN NEW;
        END;
      $$;
CREATE FUNCTION public.notify_twilio_call_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    BEGIN perform pg_notify('twilio_call_created', row_to_json(NEW)::text);
    RETURN NEW;
  END;
$$;
CREATE TABLE public.donations (
    id integer NOT NULL,
    widget_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    token character varying,
    payment_method character varying,
    amount integer,
    email character varying,
    card_hash character varying,
    customer public.hstore,
    skip boolean DEFAULT false,
    transaction_id character varying,
    transaction_status character varying DEFAULT 'pending'::character varying,
    subscription boolean,
    credit_card character varying,
    activist_id integer,
    subscription_id character varying,
    period integer,
    plan_id integer,
    parent_id integer,
    payables jsonb,
    gateway_data jsonb,
    payable_transfer_id integer,
    old_synch boolean,
    converted_from integer,
    synchronized boolean,
    local_subscription_id integer,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    checkout_data jsonb,
    cached_community_id integer,
    mobilization_id integer,
    mailchimp_status character varying(20)
);
CREATE FUNCTION public.payable_fee(d public.donations) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
    select (
    case
    when d.payables is not null and jsonb_array_length(d.payables) < 2 then
        (
            case 
            when extract(year from d.created_at) <= 2016 then        
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.15)  - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            else
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.13) - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            end
        )
    when d.payables is null then
        (
            case 
            when extract(year from d.created_at) <= 2016 then
                (d.amount / 100.0) * 0.15
            else
                (d.amount / 100.0) * 0.13
            end        
        )    
    else
        (
            select 
                ((p ->> 'amount')::integer / 100.0) - ((p ->> 'fee')::integer / 100.0)
            from jsonb_array_elements(d.payables) p
                where (p ->> 'fee')::integer <> 0
                    limit 1
        )
    end)::decimal - (case d.payment_method 
                     when 'boleto' then 0
                     else coalesce(((d.gateway_data ->> 'cost')::integer / 100.0), 0) end)
$$;
CREATE FUNCTION public.payable_fee_2(d public.donations) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
    select (
    case
    when d.payables is not null and jsonb_array_length(d.payables) < 2 then
        (
            case 
            when extract(year from d.created_at) <= 2016 then        
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.13)  - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            else
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.13) - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            end
        )
    when d.payables is null then
        (
            case 
            when extract(year from d.created_at) <= 2016 then
                (d.amount / 100.0) * 0.15
            else
                (d.amount / 100.0) * 0.13
            end        
        )    
    else
        (
            select 
                ((p ->> 'amount')::integer / 100.0) - ((p ->> 'fee')::integer / 100.0)
            from jsonb_array_elements(d.payables) p
                where (p ->> 'fee')::integer <> 0
                    limit 1
        )
    end)::decimal - (case d.payment_method 
                     when 'boleto' then 0
                     else coalesce(((d.gateway_data ->> 'cost')::integer / 100.0), 0) end)
$$;
CREATE TABLE public.plips (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    unique_identifier text NOT NULL,
    widget_id integer NOT NULL,
    form_data jsonb NOT NULL,
    pdf_data text,
    expected_signatures integer,
    state text
);
CREATE FUNCTION public.plips_confirmed_signatures(plips_row public.plips) RETURNS bigint
    LANGUAGE sql STABLE
    AS $$
  SELECT sum(ps.confirmed_signatures)
    FROM plip_signatures as ps
    WHERE ps.widget_id = plips_row.widget_id
    AND ps.unique_identifier = plips_row.unique_identifier
$$;
CREATE FUNCTION public.plips_status(p public.plips) RETURNS text
    LANGUAGE sql STABLE
    AS $$
    SELECT
        CASE
            WHEN (
                (SELECT sum(ps.confirmed_signatures) FROM plip_signatures ps WHERE ps.unique_identifier = p.unique_identifier) > 0
            ) THEN 'CONCLUIDO'
            WHEN (
                (SELECT sum(ps.confirmed_signatures) FROM plip_signatures ps WHERE ps.unique_identifier = p.unique_identifier) IS NULL AND
                (
                    ((p.form_data->>'expected_signatures')::int = 10 AND p.created_at <= NOW() - INTERVAL '30' DAY) OR
                    ((p.form_data->'expected_signatures')::int = 20 AND p.created_at <= NOW() - INTERVAL '60' DAY) OR
                    ((p.form_data->'expected_signatures')::int = 30 AND p.created_at <= NOW() - INTERVAL '90' DAY) OR
                    ((p.form_data->'expected_signatures')::int = 40 AND p.created_at <= NOW() - INTERVAL '120' DAY) OR
                    ((p.form_data->'expected_signatures')::int = 50 AND p.created_at <= NOW() - INTERVAL '150' DAY) OR
                    ((p.form_data->'expected_signatures')::int = 100 AND p.created_at <= NOW() - INTERVAL '180' DAY)
                )
            ) THEN 'PENDENTE'
            ELSE 'INSCRITO'
        END;
$$;
CREATE FUNCTION public.receiving_unpaid_notifications(public.subscriptions) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $_$
    declare
        _last_paid_donation public.donations;
    begin
        select * from donations
            where local_subscription_id = $1.id
                and transaction_status = 'paid'
                order by created_at desc
                limit 1
        into _last_paid_donation;
        if _last_paid_donation.id is not null then
            return coalesce((
                select count(1) <= 2 
                    from notifications n
                    join notification_templates nt on nt.id = n.notification_template_id
                    where nt.label = 'unpaid_subscription'
                        and (n.template_vars->>'subscription_id')::integer = $1.id
                        and n.created_at >= _last_paid_donation.created_at
            ), true);
        else
            return (
                select count(1) <= 2 
                    from notifications n
                    join notification_templates nt on nt.id = n.notification_template_id
                    where nt.label = 'unpaid_subscription'
                        and (n.template_vars->>'subscription_id')::integer = $1.id
            );
        end if;
    end;
$_$;
CREATE FUNCTION public.refresh_custom_domain_frontend() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        if new.traefik_host_rule is not null then
            perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
                'action', 'refresh_frontend',
                'id', new.id,
                'created_at', now(),
                'sent_to_queuing', now(),
                'jit', now()::timestamp
            ), public.configuration('jwt_secret'), 'HS512'));
        end if;
        return new;
    end;
$$;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE FUNCTION public.slugfy(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
        select regexp_replace(replace(unaccent(lower($1)), ' ', '-'), '[^a-z0-9-_]+', '', 'g');
    $_$;
CREATE FUNCTION public.slugify(value text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  -- removes accents (diacritic signs) from a given string --
  WITH "unaccented" AS (
    SELECT unaccent("value") AS "value"
  ),
  -- lowercases the string
  "lowercase" AS (
    SELECT lower("value") AS "value"
    FROM "unaccented"
  ),
  -- remove single and double quotes
  "removed_quotes" AS (
    SELECT regexp_replace("value", '[''"]+', '', 'gi') AS "value"
    FROM "lowercase"
  ),
  -- replaces anything that's not a letter, number, hyphen('-'), or underscore('_') with a hyphen('-')
  "hyphenated" AS (
    SELECT regexp_replace("value", '[^a-z0-9\\-_]+', '-', 'gi') AS "value"
    FROM "removed_quotes"
  ),
  -- trims hyphens('-') if they exist on the head or tail of the string
  "trimmed" AS (
    SELECT regexp_replace(regexp_replace("value", '\-+$', ''), '^\-', '') AS "value"
    FROM "hyphenated"
  )
  SELECT "value" FROM "trimmed";
$_$;
CREATE FUNCTION public.slugify(value text, allow_unicode boolean) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  WITH "normalized" AS (
    SELECT CASE
      WHEN "allow_unicode" THEN "value"
      ELSE unaccent("value")
    END AS "value"
  ),
  "remove_chars" AS (
    SELECT regexp_replace("value", E'[^\\w\\s-]', '', 'gi') AS "value"
    FROM "normalized"
  ),
  "lowercase" AS (
    SELECT lower("value") AS "value"
    FROM "remove_chars"
  ),
  "trimmed" AS (
    SELECT trim("value") AS "value"
    FROM "lowercase"
  ),
  "hyphenated" AS (
    SELECT regexp_replace("value", E'[-\\s]+', '-', 'gi') AS "value"
    FROM "trimmed"
  )
  SELECT "value" FROM "hyphenated";
$$;
CREATE FUNCTION public.update_expires() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.expires = now()::date + (3 || ' days')::interval;
    RETURN NEW;
END;
$$;
CREATE FUNCTION public.update_facebook_bot_activists_full_text_index() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_facebook_bot_activists public.facebook_bot_activists;
        v_payload jsonb;
        v_quick_reply text;
        v_messages tsvector;
        v_quick_replies text[];
    BEGIN
        SELECT *
        FROM public.facebook_bot_activists
        WHERE fb_context_recipient_id = NEW.fb_context_recipient_id
        INTO v_facebook_bot_activists;
        IF NEW.interaction ->> 'is_bot' IS NULL THEN
            v_payload := NEW.interaction -> 'payload';
            v_quick_reply := v_payload -> 'message' -> 'quick_reply' ->> 'payload';
            v_messages := CASE WHEN v_quick_reply IS NULL THEN
                public.facebook_activist_message_full_text_index(
                    v_payload -> 'message' ->> 'text'
                )
            END;
            IF v_quick_reply IS NOT NULL THEN
                v_quick_replies := ARRAY[v_quick_reply]::text[];
            END IF;
            IF v_facebook_bot_activists IS NULL THEN
                INSERT INTO public.facebook_bot_activists (
                    fb_context_recipient_id,
                    fb_context_sender_id,
                    data,
                    messages,
                    quick_replies,
                    interaction_dates,
                    created_at,
                    updated_at
                ) VALUES (
                    NEW.fb_context_recipient_id,
                    NEW.fb_context_sender_id,
                    NEW.interaction -> 'profile',
                    v_messages,
                    COALESCE(v_quick_replies, ARRAY[]::text[]),
                    ARRAY[NEW.created_at]::timestamp without time zone[],
                    NEW.created_at,
                    NEW.updated_at
                );
            ELSE
                UPDATE public.facebook_bot_activists
                SET
                    interaction_dates = ARRAY_APPEND(interaction_dates, NEW.created_at),
                    messages = CASE WHEN v_quick_reply IS NULL THEN
                        COALESCE(messages, '') || COALESCE(v_messages, '')
                    ELSE COALESCE(messages, '')
                    END,
                    quick_replies = CASE WHEN v_quick_replies IS NOT NULL THEN
                        (SELECT ARRAY_AGG(DISTINCT qr)
                        FROM UNNEST(ARRAY_CAT(quick_replies, v_quick_replies)) as qr)
                    ELSE
                        quick_replies
                    END
                WHERE fb_context_recipient_id = NEW.fb_context_recipient_id;
            END IF;
        END IF;
        RETURN NEW;
    END;
$$;
CREATE FUNCTION public.updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;
CREATE FUNCTION public.verify_custom_domain() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      CASE TG_OP
      WHEN 'INSERT' THEN
        IF NEW.custom_domain is not null then
          perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
              'action', 'verify_custom_domain',
              'id', NEW.id,
              'custom_domain', NEW.custom_domain,
              'pg_action', 'insert_custom_domain',
              'sent_to_queuing', now(),
              'jit', now()::timestamp
          ), public.configuration('jwt_secret'), 'HS512'));
        END IF;
        RETURN NEW;
      WHEN 'UPDATE' THEN
        IF NEW.custom_domain is not null then
          perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
              'action', 'verify_custom_domain',
              'id', NEW.id,
              'custom_domain', NEW.custom_domain,
              'pg_action', 'update_custom_domain',
              'sent_to_queuing', now(),
              'jit', now()::timestamp
          ), public.configuration('jwt_secret'), 'HS512'));
        END IF;
        RETURN NEW;
     WHEN 'DELETE' THEN
      perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
          'action', 'verify_custom_domain',
          'id', OLD.id,
          'custom_domain', OLD.custom_domain,
          'pg_action', 'delete_custom_domain',
          'sent_to_queuing', now(),
          'jit', now()::timestamp
      ), public.configuration('jwt_secret'), 'HS512'));
      RETURN OLD;
     ELSE
        raise  'custom_domain_not_processed';
      END CASE;
        END;
      $$;
CREATE SEQUENCE public.activist_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.activist_actions (
    action_created_at timestamp without time zone NOT NULL,
    activist_created_at timestamp without time zone NOT NULL,
    id integer DEFAULT nextval('public.activist_actions_id_seq'::regclass) NOT NULL,
    action text NOT NULL,
    widget_id integer NOT NULL,
    mobilization_id integer NOT NULL,
    community_id integer NOT NULL,
    activist_id integer NOT NULL
);
COMMENT ON TABLE public.activist_actions IS 'Tabela responsável por agregar informações sobre as ações do ativista';
CREATE TABLE public.communities (
    id integer NOT NULL,
    name character varying,
    city character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    mailchimp_api_key text,
    mailchimp_list_id text,
    mailchimp_group_id text,
    image character varying,
    description text,
    recipient_id integer,
    facebook_app_id character varying,
    fb_link character varying,
    twitter_link character varying,
    subscription_retry_interval integer DEFAULT 7,
    subscription_dead_days_interval integer DEFAULT 90,
    email_template_from character varying,
    mailchimp_sync_request_at timestamp without time zone,
    modules jsonb DEFAULT '{"settings": true, "mobilization": true}'::jsonb,
    signature jsonb,
    classification character varying(20)
);
CREATE TABLE public.mobilizations (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    color_scheme character varying,
    google_analytics_code character varying,
    goal text,
    header_font character varying,
    body_font character varying,
    facebook_share_title character varying,
    facebook_share_description text,
    facebook_share_image character varying,
    slug character varying,
    custom_domain character varying,
    twitter_share_text character varying(300),
    community_id integer,
    favicon character varying,
    deleted_at timestamp without time zone,
    status public.status_mobilization DEFAULT 'active'::public.status_mobilization,
    traefik_host_rule character varying,
    traefik_backend_address character varying,
    language character varying(5) DEFAULT 'pt-BR'::character varying,
    subtheme_tertiary integer,
    subtheme_secondary integer,
    theme integer,
    subtheme_primary integer
);
CREATE TABLE public.dns_hosted_zones (
    id integer NOT NULL,
    community_id integer,
    domain_name character varying,
    comment text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    response jsonb,
    ns_ok boolean,
    status public.dnshostedzonestatus DEFAULT 'created'::public.dnshostedzonestatus,
    is_external_domain boolean DEFAULT false NOT NULL
);
CREATE TABLE public.notification_templates (
    id integer NOT NULL,
    label text NOT NULL,
    community_id integer,
    subject_template text NOT NULL,
    body_template text NOT NULL,
    template_vars jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locale text DEFAULT 'pt-BR'::text NOT NULL,
    CONSTRAINT localechk CHECK ((locale = ANY (public.locale_names())))
);
CREATE TABLE public.notifications (
    id integer NOT NULL,
    activist_id integer,
    notification_template_id integer NOT NULL,
    template_vars jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    community_id integer,
    user_id integer,
    email character varying,
    deliver_at timestamp without time zone,
    delivered_at timestamp without time zone
);
CREATE TABLE public.activist_facebook_bot_interactions (
    id integer NOT NULL,
    activist_id integer,
    facebook_bot_configuration_id integer NOT NULL,
    fb_context_recipient_id text NOT NULL,
    fb_context_sender_id text NOT NULL,
    interaction jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE TABLE public.facebook_bot_configurations (
    id integer NOT NULL,
    community_id integer,
    messenger_app_secret text NOT NULL,
    messenger_validation_token text NOT NULL,
    messenger_page_access_token text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE TABLE public.mobilization_activists (
    id integer NOT NULL,
    mobilization_id integer NOT NULL,
    activist_id integer NOT NULL,
    search_index tsvector,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE TABLE public.balance_operations (
    id integer NOT NULL,
    recipient_id integer NOT NULL,
    gateway_data jsonb NOT NULL,
    gateway_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE TABLE public.recipients (
    id integer NOT NULL,
    pagarme_recipient_id character varying NOT NULL,
    recipient jsonb NOT NULL,
    community_id integer NOT NULL,
    transfer_day integer,
    transfer_enabled boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE VIEW public.balance_operation_summaries AS
 SELECT bo.id,
    bo.recipient_id,
    r.community_id,
    (bo.gateway_data ->> 'type'::text) AS operation_type,
    (bo.gateway_data ->> 'object'::text) AS operation_object,
    (bo.gateway_data ->> 'status'::text) AS operation_status,
    (((bo.gateway_data ->> 'amount'::text))::numeric / 100.0) AS operation_amount,
    (((bo.gateway_data ->> 'balance_amount'::text))::numeric / 100.0) AS balance_amount_at_moment,
    (((bo.gateway_data ->> 'fee'::text))::numeric / 100.0) AS operation_fee,
    ((bo.gateway_data ->> 'date_created'::text))::timestamp without time zone AS operation_created_at,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'id'::text) AS movement_object_id,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'type'::text) AS movement_object_type,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'status'::text) AS movement_object_status,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'object'::text) AS movement_object_object,
    ((((bo.gateway_data -> 'movement_object'::text) ->> 'amount'::text))::numeric / 100.0) AS movement_object_amount,
    ((((bo.gateway_data -> 'movement_object'::text) ->> 'fee'::text))::numeric / 100.0) AS movement_object_fee,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'transaction_id'::text) AS movement_object_transaction_id,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'payment_method'::text) AS movement_object_payment_method,
    (bo.gateway_data -> 'movement_object'::text) AS movement_object
   FROM (public.balance_operations bo
     JOIN public.recipients r ON ((r.id = bo.recipient_id)))
  ORDER BY ((bo.gateway_data ->> 'date_created'::text))::timestamp without time zone DESC;
CREATE TABLE public.blocks (
    id integer NOT NULL,
    mobilization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bg_class character varying,
    "position" integer,
    hidden boolean,
    bg_image text,
    name character varying,
    menu_hidden boolean,
    deleted_at timestamp without time zone
);
CREATE TABLE public.payable_transfers (
    id integer NOT NULL,
    transfer_id integer,
    transfer_data jsonb,
    transfer_status text,
    community_id integer NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE TABLE public.widgets (
    id integer NOT NULL,
    block_id integer,
    settings jsonb,
    kind character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sm_size integer,
    md_size integer,
    lg_size integer,
    mailchimp_segment_id character varying,
    action_community boolean DEFAULT false,
    exported_at timestamp without time zone,
    mailchimp_unique_segment_id character varying,
    mailchimp_recurring_active_segment_id character varying,
    mailchimp_recurring_inactive_segment_id character varying,
    goal numeric(12,2),
    deleted_at timestamp without time zone
);
CREATE VIEW public.payable_details AS
 SELECT o.id AS community_id,
    d.widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.id AS donation_id,
    d.subscription_id,
    d.transaction_id,
    (dd.value ->> 'id'::text) AS payable_id,
    (((d.amount)::numeric / 100.0))::double precision AS donation_value,
    (((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) AS payable_value,
    (payable_summary.payable_fee)::double precision AS payable_pagarme_fee,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN nossas_tx.amount
            ELSE ((((d.amount)::numeric / 100.0) * 0.13))::double precision
        END AS nossas_fee,
    nossas_tx.percent AS percent_tx,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) - (payable_summary.payable_fee)::double precision)
            ELSE ((((d.amount)::numeric / 100.0))::double precision - ((((d.amount)::numeric / 100.0) * 0.13))::double precision)
        END AS value_without_fee,
    ((dd.value ->> 'date_created'::text))::timestamp without time zone AS payment_date,
    ((dd.value ->> 'payment_date'::text))::timestamp without time zone AS payable_date,
    d.transaction_status AS pagarme_status,
    (dd.value ->> 'status'::text) AS payable_status,
    d.payment_method,
    customer.name,
    customer.email,
    pt.id AS payable_transfer_id,
    pt.transfer_data,
    d.gateway_data,
    d.subscription AS is_subscription,
    (dd.value ->> 'recipient_id'::text) AS recipient_id,
    d.local_subscription_id
   FROM (((((((((public.communities o
     JOIN public.donations d ON (((d.cached_community_id = o.id) AND ((d.transaction_status)::text = 'paid'::text))))
     LEFT JOIN public.widgets w ON ((w.id = d.widget_id)))
     LEFT JOIN public.blocks b ON ((b.id = w.block_id)))
     LEFT JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     LEFT JOIN public.payable_transfers pt ON ((pt.id = d.payable_transfer_id)))
     LEFT JOIN LATERAL ( SELECT COALESCE((d2.customer OPERATOR(public.->) 'name'::text), (d.customer OPERATOR(public.->) 'name'::text)) AS name,
            COALESCE((d2.customer OPERATOR(public.->) 'email'::text), (d.customer OPERATOR(public.->) 'email'::text)) AS email
           FROM public.donations d2
          WHERE
                CASE
                    WHEN (d.parent_id IS NULL) THEN (d2.id = d.id)
                    ELSE (d2.id = d.parent_id)
                END) customer ON (true))
     LEFT JOIN LATERAL ( SELECT data.value
           FROM jsonb_array_elements(d.payables) data(value)) dd ON (true))
     LEFT JOIN LATERAL ( SELECT (((jsonb_array_elements.value ->> 'amount'::text))::double precision / (100.0)::double precision) AS amount,
            ((((jsonb_array_elements.value ->> 'amount'::text))::double precision / (d.amount)::double precision) * (100.0)::double precision) AS percent
           FROM jsonb_array_elements(d.payables) jsonb_array_elements(value)
          WHERE ((jsonb_array_elements.value ->> 'recipient_id'::text) = public.nossas_recipient_id())) nossas_tx ON (true))
     LEFT JOIN LATERAL ( SELECT td.amount,
            td.payable_fee,
            td.transaction_cost,
            (td.amount - td.payable_fee) AS value_without_fee
           FROM ( SELECT ((((dd.value ->> 'amount'::text))::integer)::numeric / 100.0) AS amount,
                    ((((dd.value ->> 'fee'::text))::integer)::numeric / 100.0) AS payable_fee,
                    ((((d.gateway_data ->> 'cost'::text))::integer)::numeric / 100.0) AS transaction_cost) td) payable_summary ON (true))
  WHERE ((((dd.value ->> 'type'::text) = 'credit'::text) AND ((dd.value ->> 'object'::text) = 'payable'::text) AND ((dd.value ->> 'recipient_id'::text) IN ( SELECT (r.pagarme_recipient_id)::text AS pagarme_recipient_id
           FROM public.recipients r
          WHERE (r.community_id = o.id)))) OR (jsonb_array_length(d.payables) = 1));
CREATE VIEW public.activist_participations AS
SELECT
    NULL::integer AS community_id,
    NULL::integer AS mobilization_id,
    NULL::integer AS widget_id,
    NULL::integer AS activist_id,
    NULL::character varying AS email,
    NULL::timestamp without time zone AS participate_at,
    NULL::text AS participate_kind,
    NULL::integer AS participate_id;
CREATE TABLE public.__diesel_schema_migrations (
    version character varying(50) NOT NULL,
    run_on timestamp without time zone DEFAULT now() NOT NULL
);
CREATE TABLE public._temp_import_mailchimp (
    email character varying(150) NOT NULL
);
CREATE VIEW public.activist_actions_lgpd AS
 SELECT t.action,
    t.widget_id,
    t.mobilization_id,
    t.community_id,
    t.activist_id,
    t.action_created_date,
    t.activist_created_at
   FROM ( SELECT 'form_entries'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            fe.activist_id,
            fe.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.form_entries fe
             JOIN public.activists a ON ((a.id = fe.activist_id)))
             JOIN public.widgets w ON ((w.id = fe.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'activist_pressures'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            ap.activist_id,
            ap.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.activist_pressures ap
             JOIN public.activists a ON ((a.id = ap.activist_id)))
             JOIN public.widgets w ON ((w.id = ap.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'donations'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            d.activist_id,
            d.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.donations d
             JOIN public.activists a ON ((a.id = d.activist_id)))
             JOIN public.widgets w ON ((w.id = d.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))) t;
CREATE VIEW public.activist_actions_virtual AS
 SELECT t.action,
    t.widget_id,
    t.mobilization_id,
    t.community_id,
    t.activist_id,
    t.action_created_date,
    t.activist_created_at,
    t.activist_email
   FROM ( SELECT 'form_entries'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            fe.activist_id,
            fe.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.form_entries fe
             JOIN public.activists a ON ((a.id = fe.activist_id)))
             JOIN public.widgets w ON ((w.id = fe.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'activist_pressures'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            ap.activist_id,
            ap.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.activist_pressures ap
             JOIN public.activists a ON ((a.id = ap.activist_id)))
             JOIN public.widgets w ON ((w.id = ap.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'donations'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            d.activist_id,
            d.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.donations d
             JOIN public.activists a ON ((a.id = d.activist_id)))
             JOIN public.widgets w ON ((w.id = d.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))) t;
CREATE SEQUENCE public.activist_facebook_bot_interactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.activist_facebook_bot_interactions_id_seq OWNED BY public.activist_facebook_bot_interactions.id;
CREATE TABLE public.activist_matches (
    id integer NOT NULL,
    activist_id integer,
    match_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text
);
CREATE SEQUENCE public.activist_matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.activist_matches_id_seq OWNED BY public.activist_matches.id;
CREATE SEQUENCE public.activist_pressures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.activist_pressures_id_seq OWNED BY public.activist_pressures.id;
CREATE VIEW public.activist_pressures_range AS
 SELECT ap.widget_id,
    date_trunc('day'::text, ap.created_at) AS created_at,
    count(*) AS total
   FROM public.activist_pressures ap
  GROUP BY (date_trunc('day'::text, ap.created_at)), ap.widget_id
  ORDER BY ap.widget_id;
CREATE SEQUENCE public.activist_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.activist_tags_id_seq OWNED BY public.activist_tags.id;
CREATE SEQUENCE public.activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.activists_id_seq OWNED BY public.activists.id;
CREATE TABLE public.addresses (
    id integer NOT NULL,
    zipcode character varying,
    street character varying,
    street_number character varying,
    complementary character varying,
    neighborhood character varying,
    city character varying,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    activist_id integer
);
CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;
CREATE VIEW public.agg_activists AS
SELECT
    NULL::integer AS community_id,
    NULL::integer AS activist_id,
    NULL::character varying AS email,
    NULL::character varying AS name,
    NULL::bigint AS total_form_entries;
CREATE SEQUENCE public.balance_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.balance_operations_id_seq OWNED BY public.balance_operations.id;
CREATE SEQUENCE public.blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.blocks_id_seq OWNED BY public.blocks.id;
CREATE TABLE public.certificates (
    id integer NOT NULL,
    community_id integer,
    mobilization_id integer,
    dns_hosted_zone_id integer,
    domain character varying,
    file_content text,
    expire_on timestamp without time zone,
    is_active boolean,
    created_at timestamp without time zone DEFAULT now(),
    ssl_checker_response jsonb,
    updated_at timestamp with time zone DEFAULT now()
);
CREATE SEQUENCE public.certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.certificates_id_seq OWNED BY public.certificates.id;
CREATE SEQUENCE public.chatbot_campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.chatbot_campaigns (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.chatbot_campaigns_id_seq'::regclass) NOT NULL,
    name character varying NOT NULL,
    diagram jsonb,
    chatbot_id integer NOT NULL,
    status text,
    get_started boolean DEFAULT false
);
COMMENT ON TABLE public.chatbot_campaigns IS 'Tabela responsável por armazenar fluxos de conversa de um Chatbot';
CREATE SEQUENCE public.chatbot_interactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.chatbot_interactions (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.chatbot_interactions_id_seq'::regclass) NOT NULL,
    interaction jsonb NOT NULL,
    chatbot_id integer NOT NULL,
    context_recipient_id text NOT NULL,
    context_sender_id text NOT NULL
);
COMMENT ON TABLE public.chatbot_interactions IS 'Tabela responsável por contextualizar interações entre o bot e o usuário';
CREATE SEQUENCE public.chatbot_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.chatbot_settings (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.chatbot_settings_id_seq'::regclass) NOT NULL,
    channel text NOT NULL,
    settings jsonb NOT NULL,
    chatbot_id integer NOT NULL
);
COMMENT ON TABLE public.chatbot_settings IS 'Tabela responsável por armazenar as configurações dos canais usados para comunicação de um Chatbot';
CREATE SEQUENCE public.chatbots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.chatbots (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.chatbots_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    community_id integer NOT NULL,
    persistent_menu jsonb
);
COMMENT ON TABLE public.chatbots IS 'Tabela responsável por relacionar módulo Chatbot com módulo Comunidade';
CREATE SEQUENCE public.communities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.communities_id_seq OWNED BY public.communities.id;
CREATE SEQUENCE public.community_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.community_activists_id_seq OWNED BY public.community_activists.id;
CREATE TABLE public.community_settings (
    id bigint NOT NULL,
    name character varying NOT NULL,
    settings json,
    version integer DEFAULT 1 NOT NULL,
    community_id bigint NOT NULL
);
CREATE SEQUENCE public.community_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.community_users_id_seq OWNED BY public.community_users.id;
CREATE TABLE public.configurations (
    id integer NOT NULL,
    name character varying NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;
CREATE TABLE public.credit_cards (
    id integer NOT NULL,
    activist_id integer,
    last_digits character varying,
    card_brand character varying,
    card_id character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    expiration_date character varying
);
CREATE SEQUENCE public.credit_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.credit_cards_id_seq OWNED BY public.credit_cards.id;
CREATE SEQUENCE public.dns_hosted_zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.dns_hosted_zones_id_seq OWNED BY public.dns_hosted_zones.id;
CREATE TABLE public.dns_records (
    id integer NOT NULL,
    dns_hosted_zone_id integer,
    name character varying,
    record_type character varying,
    value text,
    ttl integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    comment character varying
);
CREATE SEQUENCE public.dns_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.dns_records_id_seq OWNED BY public.dns_records.id;
CREATE VIEW public.donation_reports AS
 SELECT m.id AS mobilization_id,
    w.id AS widget_id,
    c.id AS community_id,
    d.id,
    d.transaction_id,
    d.transaction_status AS status,
    to_char(d.created_at, 'dd/mm/YYYY'::text) AS data,
    COALESCE((d.customer OPERATOR(public.->) 'name'::text), (a.name)::text) AS nome,
    d.email,
    d.payment_method AS "cartao/boleto",
        CASE
            WHEN (d.subscription OR (d.local_subscription_id IS NOT NULL)) THEN 'Sim'::text
            ELSE 'Não'::text
        END AS recorrente,
    (((d.amount)::numeric / 100.0))::double precision AS valor,
    pd.value_without_fee AS "valor garantido",
    to_char(((d.gateway_data ->> 'boleto_expiration_date'::text))::timestamp without time zone, 'dd/mm/YYYY'::text) AS "data vencimento boleto",
    recurrency_donation.count AS "recorrencia da doacao",
    recurrency_activist.count AS "recorrencia do ativista",
    (gs.status)::text AS subscription_status,
    pd.payable_date AS "data de recebimento"
   FROM (((((((((((public.donations d
     JOIN public.widgets w ON ((w.id = d.widget_id)))
     JOIN public.blocks b ON ((b.id = w.block_id)))
     JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     JOIN public.communities c ON ((c.id = m.community_id)))
     LEFT JOIN public.subscriptions gs ON ((gs.id = d.local_subscription_id)))
     LEFT JOIN public.payable_details pd ON ((pd.donation_id = d.id)))
     LEFT JOIN public.activists a ON ((a.id = d.activist_id)))
     LEFT JOIN LATERAL ( SELECT (((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) customer_phone ON (true))
     LEFT JOIN LATERAL ( SELECT (((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) activist_phone ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.local_subscription_id IS NOT NULL) AND (d2.local_subscription_id = d.local_subscription_id))) recurrency_donation ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.activist_id = d.activist_id) AND (d2.cached_community_id = d.cached_community_id) AND (d.activist_id IS NOT NULL))) recurrency_activist ON (true))
  WHERE (d.transaction_id IS NOT NULL);
CREATE VIEW public.donation_reports_2 AS
 SELECT m.id AS mobilization_id,
    w.id AS widget_id,
    c.id AS community_id,
    d.id,
    d.transaction_id,
    d.transaction_status AS status,
    to_char(d.created_at, 'dd/mm/YYYY'::text) AS data,
    COALESCE((d.customer OPERATOR(public.->) 'name'::text), (a.name)::text) AS nome,
    d.email,
    COALESCE(customer_phone.number, activist_phone.number) AS telefone,
    d.payment_method AS "cartao/boleto",
        CASE
            WHEN (d.subscription OR (d.local_subscription_id IS NOT NULL)) THEN 'Sim'::text
            ELSE 'Não'::text
        END AS recorrente,
    (((d.amount)::numeric / 100.0))::double precision AS valor,
    pd.value_without_fee AS "valor garantido",
    to_char(((d.gateway_data ->> 'boleto_expiration_date'::text))::timestamp without time zone, 'dd/mm/YYYY'::text) AS "data vencimento boleto",
    recurrency_donation.count AS "recorrencia da doacao",
    recurrency_activist.count AS "recorrencia do ativista",
    (gs.status)::text AS subscription_status,
    pd.payable_date AS "data de recebimento"
   FROM (((((((((((public.donations d
     JOIN public.widgets w ON ((w.id = d.widget_id)))
     JOIN public.blocks b ON ((b.id = w.block_id)))
     JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     JOIN public.communities c ON ((c.id = m.community_id)))
     LEFT JOIN public.subscriptions gs ON ((gs.id = d.local_subscription_id)))
     LEFT JOIN public.payable_details pd ON ((pd.donation_id = d.id)))
     LEFT JOIN public.activists a ON ((a.id = d.activist_id)))
     LEFT JOIN LATERAL ( SELECT (((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) customer_phone ON (true))
     LEFT JOIN LATERAL ( SELECT (((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) activist_phone ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.local_subscription_id IS NOT NULL) AND (d2.local_subscription_id = d.local_subscription_id))) recurrency_donation ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.activist_id = d.activist_id) AND (d.activist_id IS NOT NULL))) recurrency_activist ON (true))
  WHERE (d.transaction_id IS NOT NULL);
CREATE VIEW public.donation_transactions AS
 SELECT d.id AS donation_id,
    COALESCE(c.id, d.cached_community_id) AS community_id,
    w.id AS widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.activist_id,
    d.email AS donation_email,
    (d.amount / 100) AS donation_amount,
    d.local_subscription_id AS subscription_id,
    d.transaction_status,
    COALESCE(((d.gateway_data ->> 'date_created'::text))::timestamp without time zone, d.created_at) AS payment_date,
    pd.payable_date,
    pd.payable_value AS payable_amount,
    pd.payable_status,
    s.status AS subscription_status
   FROM ((((((public.donations d
     JOIN public.widgets w ON ((w.id = d.widget_id)))
     LEFT JOIN public.blocks b ON ((b.id = w.block_id)))
     LEFT JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     LEFT JOIN public.communities c ON (((c.id = m.community_id) OR (c.id = d.cached_community_id))))
     LEFT JOIN public.subscriptions s ON ((s.id = d.local_subscription_id)))
     LEFT JOIN public.payable_details pd ON ((pd.donation_id = d.id)))
  WHERE (d.transaction_id IS NOT NULL);
CREATE TABLE public.donation_transitions (
    id integer NOT NULL,
    to_state character varying NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    sort_key integer NOT NULL,
    donation_id integer NOT NULL,
    most_recent boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.donation_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.donation_transitions_id_seq OWNED BY public.donation_transitions.id;
CREATE SEQUENCE public.donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.donations_id_seq OWNED BY public.donations.id;
CREATE TABLE public.donations_integration_logs (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    widget_id integer NOT NULL,
    community_id integer NOT NULL,
    integration_id integer NOT NULL,
    message text,
    donation_id integer NOT NULL
);
COMMENT ON TABLE public.donations_integration_logs IS 'Tabela responsável por armazenar logs das integrações realizadas a cada doação.';
CREATE SEQUENCE public.donations_integration_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.donations_integration_logs_id_seq OWNED BY public.donations_integration_logs.id;
CREATE VIEW public.donations_lgpd AS
 SELECT donations.id,
    donations.widget_id,
    donations.created_at,
    donations.updated_at,
    donations.payment_method,
    donations.amount,
    donations.skip,
    donations.transaction_id,
    donations.transaction_status,
    donations.subscription,
    donations.activist_id,
    donations.subscription_id,
    donations.period,
    donations.plan_id,
    donations.parent_id,
    donations.payable_transfer_id,
    donations.synchronized,
    donations.local_subscription_id,
    donations.mailchimp_syncronization_at,
    donations.mailchimp_syncronization_error_reason,
    donations.cached_community_id,
    donations.mobilization_id
   FROM public.donations;
CREATE TABLE public.facebook_bot_activists (
    id integer NOT NULL,
    fb_context_recipient_id text NOT NULL,
    fb_context_sender_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    messages tsvector,
    quick_replies text[] DEFAULT '{}'::text[],
    interaction_dates timestamp without time zone[] DEFAULT '{}'::timestamp without time zone[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.facebook_bot_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.facebook_bot_activists_id_seq OWNED BY public.facebook_bot_activists.id;
CREATE SEQUENCE public.facebook_bot_campaign_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.facebook_bot_campaign_activists_id_seq OWNED BY public.facebook_bot_campaign_activists.id;
CREATE SEQUENCE public.facebook_bot_campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.facebook_bot_campaigns_id_seq OWNED BY public.facebook_bot_campaigns.id;
CREATE SEQUENCE public.facebook_bot_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.facebook_bot_configurations_id_seq OWNED BY public.facebook_bot_configurations.id;
CREATE VIEW public.first_email_ids_activists AS
 SELECT min(activists.id) AS min_id,
    lower((activists.email)::text) AS email,
    array_agg(activists.id) AS ids
   FROM public.activists
  GROUP BY activists.email;
CREATE SEQUENCE public.form_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.form_entries_id_seq OWNED BY public.form_entries.id;
CREATE TABLE public.forms_integration_logs (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    widget_id integer NOT NULL,
    community_id integer NOT NULL,
    integration_id integer NOT NULL,
    message text,
    form_entry_id integer NOT NULL
);
COMMENT ON TABLE public.forms_integration_logs IS 'Tabela responsável por armazenar logs das integrações realizadas a cada ação.';
CREATE SEQUENCE public.forms_integration_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.forms_integration_logs_id_seq OWNED BY public.forms_integration_logs.id;
CREATE TABLE public.gateway_subscriptions (
    id integer NOT NULL,
    subscription_id integer,
    gateway_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.gateway_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.gateway_subscriptions_id_seq OWNED BY public.gateway_subscriptions.id;
CREATE TABLE public.gateway_transactions (
    id integer NOT NULL,
    transaction_id text,
    gateway_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.gateway_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.gateway_transactions_id_seq OWNED BY public.gateway_transactions.id;
CREATE TABLE public.integrations (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    community_id integer NOT NULL,
    name character varying(50) NOT NULL,
    credentials jsonb NOT NULL
);
COMMENT ON TABLE public.integrations IS 'Tabela responsável por armazenar informações das configurações dass integrações usadas numa comunidade.';
CREATE SEQUENCE public.integrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.integrations_id_seq OWNED BY public.integrations.id;
CREATE TABLE public.integrations_logs (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    widget_id integer NOT NULL,
    community_id integer NOT NULL,
    integration_id integer NOT NULL,
    message text,
    action_type character varying(50) NOT NULL,
    action_id integer NOT NULL
);
COMMENT ON TABLE public.integrations_logs IS 'Tabela responsável por armazenar logs das integrações realizadas a cada ação.';
CREATE SEQUENCE public.integrations_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.integrations_logs_id_seq OWNED BY public.integrations_logs.id;
CREATE SEQUENCE public.invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.invitations_id_seq OWNED BY public.invitations.id;
CREATE TABLE public.matches (
    id integer NOT NULL,
    widget_id integer,
    first_choice character varying,
    second_choice character varying,
    goal_image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.matches_id_seq OWNED BY public.matches.id;
CREATE SEQUENCE public.mobilization_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.mobilization_activists_id_seq OWNED BY public.mobilization_activists.id;
CREATE SEQUENCE public.mobilizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.mobilizations_id_seq OWNED BY public.mobilizations.id;
CREATE SEQUENCE public.notification_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.notification_templates_id_seq OWNED BY public.notification_templates.id;
CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;
CREATE SEQUENCE public.notify_mail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE VIEW public.participations AS
SELECT
    NULL::integer AS community_id,
    NULL::integer AS mobilization_id,
    NULL::integer AS widget_id,
    NULL::integer AS activist_id,
    NULL::character varying AS email,
    NULL::timestamp without time zone AS participate_at,
    NULL::text AS participate_kind,
    NULL::integer AS participate_id;
CREATE VIEW public.payable_details_2 AS
 SELECT o.id AS community_id,
    d.widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.id AS donation_id,
    d.subscription_id,
    d.transaction_id,
    (dd.value ->> 'id'::text) AS payable_id,
    (((d.amount)::numeric / 100.0))::double precision AS donation_value,
        CASE
            WHEN (jsonb_array_length(d.payables) = 1) THEN ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) - ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) * (0.13)::double precision))
            ELSE (((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision)
        END AS payable_value,
    (payable_summary.payable_fee)::double precision AS payable_pagarme_fee,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN nossas_tx.amount
            ELSE ((((d.amount)::numeric / 100.0) * 0.13))::double precision
        END AS nossas_fee,
    nossas_tx.percent AS percent_tx,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) - (payable_summary.payable_fee)::double precision)
            ELSE ((((d.amount)::numeric / 100.0))::double precision - ((((d.amount)::numeric / 100.0) * 0.13))::double precision)
        END AS value_without_fee,
    ((dd.value ->> 'date_created'::text))::timestamp without time zone AS payment_date,
    ((dd.value ->> 'payment_date'::text))::timestamp without time zone AS payable_date,
    d.transaction_status AS pagarme_status,
    (dd.value ->> 'status'::text) AS payable_status,
    d.payment_method,
    customer.name,
    customer.email,
    pt.id AS payable_transfer_id,
    pt.transfer_data,
    d.gateway_data,
    d.subscription AS is_subscription,
    (dd.value ->> 'recipient_id'::text) AS recipient_id,
    d.local_subscription_id
   FROM (((((((((public.communities o
     JOIN public.donations d ON (((d.cached_community_id = o.id) AND ((d.transaction_status)::text = 'paid'::text))))
     LEFT JOIN public.widgets w ON ((w.id = d.widget_id)))
     LEFT JOIN public.blocks b ON ((b.id = w.block_id)))
     LEFT JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     LEFT JOIN public.payable_transfers pt ON ((pt.id = d.payable_transfer_id)))
     LEFT JOIN LATERAL ( SELECT COALESCE((d2.customer OPERATOR(public.->) 'name'::text), (d.customer OPERATOR(public.->) 'name'::text)) AS name,
            COALESCE((d2.customer OPERATOR(public.->) 'email'::text), (d.customer OPERATOR(public.->) 'email'::text)) AS email
           FROM public.donations d2
          WHERE
                CASE
                    WHEN (d.parent_id IS NULL) THEN (d2.id = d.id)
                    ELSE (d2.id = d.parent_id)
                END) customer ON (true))
     LEFT JOIN LATERAL ( SELECT data.value
           FROM jsonb_array_elements(d.payables) data(value)) dd ON (true))
     LEFT JOIN LATERAL ( SELECT (((jsonb_array_elements.value ->> 'amount'::text))::double precision / (100.0)::double precision) AS amount,
            ((((jsonb_array_elements.value ->> 'amount'::text))::double precision / (d.amount)::double precision) * (100.0)::double precision) AS percent
           FROM jsonb_array_elements(d.payables) jsonb_array_elements(value)
          WHERE ((jsonb_array_elements.value ->> 'recipient_id'::text) = public.nossas_recipient_id())) nossas_tx ON (true))
     LEFT JOIN LATERAL ( SELECT td.amount,
            td.payable_fee,
            td.transaction_cost,
            (td.amount - td.payable_fee) AS value_without_fee
           FROM ( SELECT ((((dd.value ->> 'amount'::text))::integer)::numeric / 100.0) AS amount,
                    ((((dd.value ->> 'fee'::text))::integer)::numeric / 100.0) AS payable_fee,
                    ((((d.gateway_data ->> 'cost'::text))::integer)::numeric / 100.0) AS transaction_cost) td) payable_summary ON (true))
  WHERE ((((dd.value ->> 'type'::text) = 'credit'::text) AND ((dd.value ->> 'object'::text) = 'payable'::text) AND ((dd.value ->> 'recipient_id'::text) IN ( SELECT (r.pagarme_recipient_id)::text AS pagarme_recipient_id
           FROM public.recipients r
          WHERE (r.community_id = o.id)))) OR (jsonb_array_length(d.payables) = 1));
CREATE SEQUENCE public.payable_transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.payable_transfers_id_seq OWNED BY public.payable_transfers.id;
CREATE TABLE public.payments (
    id integer NOT NULL,
    transaction_status character varying,
    transaction_id character varying,
    plan_id integer,
    donation_id integer,
    subscription_id character varying,
    activist_id integer,
    address_id integer,
    credit_card_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;
CREATE TABLE public.plans (
    id integer NOT NULL,
    plan_id character varying,
    name character varying,
    amount integer,
    days integer,
    payment_methods text[] DEFAULT '{credit_card,boleto}'::text[],
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
CREATE SEQUENCE public.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;
CREATE TABLE public.plip_signatures (
    id integer NOT NULL,
    widget_id integer NOT NULL,
    confirmed_signatures integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    unique_identifier text NOT NULL
);
COMMENT ON TABLE public.plip_signatures IS 'Tabela responsável por armazenar assinaturas confirmadas em formulários PLIP';
COMMENT ON COLUMN public.plip_signatures.unique_identifier IS 'Atributo responsável por relacionar assinaturas confirmadas com formulários PLIP';
CREATE SEQUENCE public.plip_signatures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.plip_signatures_id_seq OWNED BY public.plip_signatures.id;
CREATE VIEW public.plips_by_state AS
 SELECT subquery.widget_id,
    sum(subquery.expected_signatures) AS expected_signatures,
    sum(subquery.confirmed_signatures) AS confirmed_signatures,
    subquery.state,
    count(*) AS subscribers
   FROM ( SELECT p.widget_id,
            sum(p.expected_signatures) AS expected_signatures,
            p.unique_identifier,
            p.state,
            ( SELECT sum(ps.confirmed_signatures) AS sum
                   FROM public.plip_signatures ps
                  WHERE (ps.unique_identifier = p.unique_identifier)) AS confirmed_signatures
           FROM public.plips p
          GROUP BY p.widget_id, p.unique_identifier, p.state) subquery
  GROUP BY subquery.state, subquery.widget_id;
CREATE SEQUENCE public.plips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.plips_id_seq OWNED BY public.plips.id;
CREATE TABLE public.plips_integration_logs (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    widget_id integer NOT NULL,
    community_id integer NOT NULL,
    integration_id integer NOT NULL,
    message text,
    plip_id integer NOT NULL
);
COMMENT ON TABLE public.plips_integration_logs IS 'Tabela responsável por armazenar logs das integrações realizadas a cada registro plip.';
CREATE SEQUENCE public.plips_integration_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.plips_integration_logs_id_seq OWNED BY public.plips_integration_logs.id;
CREATE VIEW public.plips_subscribers_range AS
 SELECT p.widget_id,
    date_trunc('day'::text, p.created_at) AS created_at,
    count(*) AS total
   FROM public.plips p
  GROUP BY (date_trunc('day'::text, p.created_at)), p.widget_id
  ORDER BY p.widget_id;
CREATE SEQUENCE public.pressure_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.pressure_targets (
    id integer DEFAULT nextval('public.pressure_targets_id_seq'::regclass) NOT NULL,
    widget_id integer NOT NULL,
    targets jsonb,
    identify character varying NOT NULL,
    label character varying NOT NULL,
    email_subject character varying,
    email_body character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.pressures_integration_logs (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    widget_id integer NOT NULL,
    community_id integer NOT NULL,
    integration_id integer NOT NULL,
    message text,
    pressure_id integer NOT NULL
);
COMMENT ON TABLE public.pressures_integration_logs IS 'Tabela responsável por armazenar logs das integrações realizadas a cada pressão.';
CREATE SEQUENCE public.pressures_integration_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.pressures_integration_logs_id_seq OWNED BY public.pressures_integration_logs.id;
CREATE SEQUENCE public.recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.recipients_id_seq OWNED BY public.recipients.id;
CREATE SEQUENCE public.rede_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.rede_groups (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.rede_groups_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    is_volunteer boolean DEFAULT false NOT NULL,
    community_id integer NOT NULL,
    widget_id integer NOT NULL,
    metadata jsonb NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL
);
COMMENT ON TABLE public.rede_groups IS 'Tabela responsável por relacionar módulo Rede com Comunidade e Widget';
CREATE SEQUENCE public.rede_individuals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.rede_individuals (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.rede_individuals_id_seq'::regclass) NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    address text,
    city text,
    state text,
    whatsapp text NOT NULL,
    rede_group_id integer NOT NULL,
    form_entry_id integer NOT NULL,
    first_name character varying NOT NULL,
    coordinates jsonb,
    zipcode character varying(100) NOT NULL,
    status character varying DEFAULT 'inscrita'::character varying,
    availability character varying DEFAULT 'indisponível'::character varying,
    extras jsonb,
    last_name character varying
);
COMMENT ON TABLE public.rede_individuals IS 'Tabela responsável por armazenar os indivíduos da rede separados por grupo';
CREATE SEQUENCE public.rede_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.rede_relationships (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.rede_relationships_id_seq'::regclass) NOT NULL,
    is_archived boolean DEFAULT false,
    comments text,
    status text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    metadata jsonb,
    volunteer_id integer NOT NULL,
    recipient_id integer NOT NULL,
    user_id integer NOT NULL
);
COMMENT ON TABLE public.rede_relationships IS 'Tabela responsável por armazenar acompanhamento de um relacionamento seja com a inscrição na rede, seja entre voluntário e beneficiário.';
CREATE SEQUENCE public.rede_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.schema_migrations (
    version character varying NOT NULL,
    id integer NOT NULL
);
CREATE SEQUENCE public.schema_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.schema_migrations_id_seq OWNED BY public.schema_migrations.id;
CREATE TABLE public.solidarity_matches (
    id integer NOT NULL,
    individuals_ticket_id bigint,
    volunteers_ticket_id bigint,
    individuals_user_id bigint,
    volunteers_user_id bigint,
    community_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    status text
);
CREATE SEQUENCE public.solidarity_matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.solidarity_matches_id_seq OWNED BY public.solidarity_matches.id;
CREATE SEQUENCE public.webhooks_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
CREATE TABLE public.webhooks_registry (
    id integer DEFAULT nextval('public.webhooks_registry_id_seq'::regclass) NOT NULL,
    data jsonb NOT NULL,
    service_name character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE VIEW public.solidarity_mautic_form AS
 SELECT (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'form'::text) -> 'name'::text) AS form_name,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'primeiro_nome'::text) AS name,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'sobrenome_completo'::text) AS firstname,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'email'::text) AS email,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'whatsapp_com_ddd'::text) AS whatsapp,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'telefone_de_atendimento_c'::text) AS phone,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'cep'::text) AS zip,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'cor'::text) AS color,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'qual_sua_area_de_atuacao'::text) AS occupation_area,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'insira_seu_numero_de_regi'::text) AS register_number,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'sendo_voluntaria_do_mapa'::text) AS attendance_availability,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'quantas_vezes_voce_ja_rec'::text) AS attendance_referrals,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'atualmente_quantas_mulher'::text) AS attendance_number,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'quanto_atendimentos_pelo'::text) AS attendance_completed,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'todos_os_atendimentos_rea'::text) AS guideline_expenses,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'as_voluntarias_do_mapa_do'::text) AS guideline_secrecy,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'o_comprometimento_a_dedic'::text) AS guideline_time_availability,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'o_mapa_do_acolhimento_ent'::text) AS guideline_support_help,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'para_que_as_mulheres_que'::text) AS guideline_termination_protocol,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'no_seu_primeiro_atendimen'::text) AS study_case_1,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'para_voce_o_que_e_mais_im'::text) AS study_case_2,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'durante_os_encontros_ana'::text) AS study_case_3,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'durante_os_atendimentos_a'::text) AS study_case_4,
    (((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'timestamp'::text) AS "timestamp"
   FROM public.webhooks_registry
  WHERE ((webhooks_registry.service_name)::text = 'mautic_form'::text);
CREATE TABLE public.solidarity_tickets (
    id integer NOT NULL,
    assignee_id bigint,
    created_at timestamp without time zone,
    custom_fields jsonb,
    description text,
    group_id bigint,
    ticket_id bigint NOT NULL,
    organization_id bigint,
    raw_subject text,
    requester_id bigint,
    status text,
    subject text,
    submitter_id bigint,
    tags jsonb,
    updated_at timestamp without time zone,
    status_acolhimento text,
    nome_voluntaria text,
    link_match text,
    nome_msr text,
    data_inscricao_bonde text,
    data_encaminhamento text,
    status_inscricao text,
    telefone text,
    estado text,
    cidade text,
    community_id integer,
    external_id bigint,
    atrelado_ao_ticket bigint,
    match_syncronized boolean DEFAULT true NOT NULL
);
CREATE SEQUENCE public.solidarity_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.solidarity_tickets_id_seq OWNED BY public.solidarity_tickets.id;
CREATE TABLE public.solidarity_users (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    url text,
    name text,
    email text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    time_zone text,
    iana_time_zone text,
    phone text,
    shared_phone_number boolean,
    photo jsonb,
    locale_id bigint,
    locale text,
    organization_id bigint,
    role text,
    verified boolean,
    external_id bigint,
    tags jsonb,
    alias text,
    active boolean,
    shared boolean,
    shared_agent boolean,
    last_login_at timestamp without time zone,
    two_factor_auth_enabled boolean,
    signature text,
    details text,
    notes text,
    role_type bigint,
    custom_role_id bigint,
    moderator boolean,
    ticket_restriction text,
    only_private_comments boolean,
    restricted_agent boolean,
    suspended boolean,
    chat_only boolean,
    default_group_id bigint,
    report_csv boolean,
    user_fields jsonb,
    address text,
    atendimentos_concludos_calculado_ bigint,
    atendimentos_concluidos bigint,
    atendimentos_em_andamento bigint,
    atendimentos_em_andamento_calculado_ bigint,
    cep text,
    city text,
    condition text,
    cor text,
    data_de_inscricao_no_bonde timestamp without time zone,
    disponibilidade_de_atendimentos text,
    encaminhamentos bigint,
    encaminhamentos_realizados_calculado_ bigint,
    latitude text,
    longitude text,
    occupation_area text,
    registration_number text,
    state text,
    tipo_de_acolhimento text,
    ultima_atualizacao_de_dados timestamp without time zone,
    whatsapp text,
    permanently_deleted boolean,
    community_id integer
);
CREATE SEQUENCE public.solidarity_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.solidarity_users_id_seq OWNED BY public.solidarity_users.id;
CREATE TABLE public.solidarity_zd_tickets (
    id integer NOT NULL,
    assignee_id bigint,
    created_at timestamp without time zone,
    custom_fields jsonb,
    description text,
    group_id bigint,
    ticket_id bigint NOT NULL,
    organization_id bigint,
    raw_subject text,
    requester_id bigint,
    status text,
    subject text,
    submitter_id bigint,
    tags jsonb,
    updated_at timestamp without time zone,
    status_acolhimento text,
    nome_voluntaria text,
    link_match text,
    nome_msr text,
    data_inscricao_bonde timestamp without time zone,
    data_encaminhamento timestamp without time zone,
    status_inscricao text,
    telefone text,
    estado text,
    cidade text,
    community_id bigint
);
CREATE SEQUENCE public.solidarity_zd_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.solidarity_zd_tickets_id_seq OWNED BY public.solidarity_zd_tickets.id;
CREATE TABLE public.subscription_transitions (
    id integer NOT NULL,
    to_state character varying NOT NULL,
    metadata json DEFAULT '{}'::json,
    sort_key integer NOT NULL,
    subscription_id integer NOT NULL,
    most_recent boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE VIEW public.subscription_reports AS
 SELECT s.community_id,
    a.name AS "Nome do doador",
    a.email AS "Email do doador",
    (((s.amount)::numeric / 100.0))::numeric(13,2) AS "Valor de doação",
    s.status AS "Status de assinatura",
    s.payment_method AS "Forma de doação (boleto/cartão)",
    s.id AS "ID da assinatura",
    s.created_at AS "Data de início da assinatura",
        CASE
            WHEN ((s.status)::text = 'canceled'::text) THEN ct.created_at
            ELSE NULL::timestamp without time zone
        END AS "Data do cancelamento da assinatura",
        CASE
            WHEN ((s.status)::text = 'unpaid'::text) THEN
            CASE
                WHEN public.receiving_unpaid_notifications(s.*) THEN 'Sim'::text
                ELSE 'Não'::text
            END
            ELSE NULL::text
        END AS "recebendo notificações?",
    ((('https://app.bonde.org/subscriptions/'::text || s.id) || '/edit?token='::text) || s.token) AS "Link de alteração da assinatura"
   FROM (((public.subscriptions s
     JOIN public.activists a ON ((a.id = s.activist_id)))
     LEFT JOIN LATERAL ( SELECT st.id,
            st.to_state,
            st.metadata,
            st.sort_key,
            st.subscription_id,
            st.most_recent,
            st.created_at,
            st.updated_at
           FROM public.subscription_transitions st
          WHERE ((st.subscription_id = s.id) AND ((st.to_state)::text = 'canceled'::text))
          ORDER BY st.created_at DESC
         LIMIT 1) ct ON (true))
     LEFT JOIN LATERAL ( SELECT n.id,
            n.activist_id,
            n.notification_template_id,
            n.template_vars,
            n.created_at,
            n.updated_at,
            n.community_id,
            n.user_id,
            n.email,
            n.deliver_at,
            n.delivered_at
           FROM (public.notifications n
             JOIN public.notification_templates nt ON ((nt.id = n.notification_template_id)))
          WHERE ((nt.label = 'unpaid_subscription'::text) AND (((n.template_vars ->> 'subscription_id'::text))::integer = s.id))
          ORDER BY n.created_at DESC
         LIMIT 1) last_unpaid_notification ON (true));
CREATE SEQUENCE public.subscription_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.subscription_transitions_id_seq OWNED BY public.subscription_transitions.id;
CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;
CREATE SEQUENCE public.taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;
CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;
CREATE TABLE public.template_blocks (
    id integer NOT NULL,
    template_mobilization_id integer,
    bg_class character varying,
    "position" integer,
    hidden boolean,
    bg_image text,
    name character varying,
    menu_hidden boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.template_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.template_blocks_id_seq OWNED BY public.template_blocks.id;
CREATE SEQUENCE public.template_mobilizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.template_mobilizations_id_seq OWNED BY public.template_mobilizations.id;
CREATE TABLE public.template_widgets (
    id integer NOT NULL,
    template_block_id integer,
    settings public.hstore,
    kind character varying,
    sm_size integer,
    md_size integer,
    lg_size integer,
    mailchimp_segment_id character varying,
    action_community boolean,
    exported_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.template_widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.template_widgets_id_seq OWNED BY public.template_widgets.id;
CREATE TABLE public.twilio_call_transitions (
    id integer NOT NULL,
    twilio_account_sid text NOT NULL,
    twilio_call_sid text NOT NULL,
    twilio_parent_call_sid text,
    sequence_number integer NOT NULL,
    status text NOT NULL,
    called text NOT NULL,
    caller text NOT NULL,
    call_duration text,
    data text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
CREATE SEQUENCE public.twilio_call_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.twilio_call_transitions_id_seq OWNED BY public.twilio_call_transitions.id;
CREATE SEQUENCE public.twilio_calls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.twilio_calls_id_seq OWNED BY public.twilio_calls.id;
CREATE SEQUENCE public.twilio_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.twilio_configurations_id_seq OWNED BY public.twilio_configurations.id;
CREATE TABLE public.user_tags (
    id integer NOT NULL,
    user_id integer,
    tag_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.user_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.user_tags_id_seq OWNED BY public.user_tags.id;
CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
CREATE VIEW public.widget_settings_targets_2 AS
 SELECT widgets.id AS widget_id,
    (widgets.settings -> 'targets'::text) AS targets
   FROM public.widgets
  WHERE (((widgets.kind)::text = 'pressure'::text) AND ((widgets.settings ->> 'targets'::text) IS NOT NULL) AND ((widgets.settings ->> 'targets'::text) <> ''::text) AND ((widgets.settings ->> 'targets'::text) !~~ '%;%'::text));
CREATE SEQUENCE public.widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.widgets_id_seq OWNED BY public.widgets.id;
ALTER TABLE ONLY public.activist_facebook_bot_interactions ALTER COLUMN id SET DEFAULT nextval('public.activist_facebook_bot_interactions_id_seq'::regclass);
ALTER TABLE ONLY public.activist_matches ALTER COLUMN id SET DEFAULT nextval('public.activist_matches_id_seq'::regclass);
ALTER TABLE ONLY public.activist_pressures ALTER COLUMN id SET DEFAULT nextval('public.activist_pressures_id_seq'::regclass);
ALTER TABLE ONLY public.activist_tags ALTER COLUMN id SET DEFAULT nextval('public.activist_tags_id_seq'::regclass);
ALTER TABLE ONLY public.activists ALTER COLUMN id SET DEFAULT nextval('public.activists_id_seq'::regclass);
ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);
ALTER TABLE ONLY public.balance_operations ALTER COLUMN id SET DEFAULT nextval('public.balance_operations_id_seq'::regclass);
ALTER TABLE ONLY public.blocks ALTER COLUMN id SET DEFAULT nextval('public.blocks_id_seq'::regclass);
ALTER TABLE ONLY public.certificates ALTER COLUMN id SET DEFAULT nextval('public.certificates_id_seq'::regclass);
ALTER TABLE ONLY public.communities ALTER COLUMN id SET DEFAULT nextval('public.communities_id_seq'::regclass);
ALTER TABLE ONLY public.community_activists ALTER COLUMN id SET DEFAULT nextval('public.community_activists_id_seq'::regclass);
ALTER TABLE ONLY public.community_users ALTER COLUMN id SET DEFAULT nextval('public.community_users_id_seq'::regclass);
ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);
ALTER TABLE ONLY public.credit_cards ALTER COLUMN id SET DEFAULT nextval('public.credit_cards_id_seq'::regclass);
ALTER TABLE ONLY public.dns_hosted_zones ALTER COLUMN id SET DEFAULT nextval('public.dns_hosted_zones_id_seq'::regclass);
ALTER TABLE ONLY public.dns_records ALTER COLUMN id SET DEFAULT nextval('public.dns_records_id_seq'::regclass);
ALTER TABLE ONLY public.donation_transitions ALTER COLUMN id SET DEFAULT nextval('public.donation_transitions_id_seq'::regclass);
ALTER TABLE ONLY public.donations ALTER COLUMN id SET DEFAULT nextval('public.donations_id_seq'::regclass);
ALTER TABLE ONLY public.donations_integration_logs ALTER COLUMN id SET DEFAULT nextval('public.donations_integration_logs_id_seq'::regclass);
ALTER TABLE ONLY public.facebook_bot_activists ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_activists_id_seq'::regclass);
ALTER TABLE ONLY public.facebook_bot_campaign_activists ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_campaign_activists_id_seq'::regclass);
ALTER TABLE ONLY public.facebook_bot_campaigns ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_campaigns_id_seq'::regclass);
ALTER TABLE ONLY public.facebook_bot_configurations ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_configurations_id_seq'::regclass);
ALTER TABLE ONLY public.form_entries ALTER COLUMN id SET DEFAULT nextval('public.form_entries_id_seq'::regclass);
ALTER TABLE ONLY public.forms_integration_logs ALTER COLUMN id SET DEFAULT nextval('public.forms_integration_logs_id_seq'::regclass);
ALTER TABLE ONLY public.gateway_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.gateway_subscriptions_id_seq'::regclass);
ALTER TABLE ONLY public.gateway_transactions ALTER COLUMN id SET DEFAULT nextval('public.gateway_transactions_id_seq'::regclass);
ALTER TABLE ONLY public.integrations ALTER COLUMN id SET DEFAULT nextval('public.integrations_id_seq'::regclass);
ALTER TABLE ONLY public.integrations_logs ALTER COLUMN id SET DEFAULT nextval('public.integrations_logs_id_seq'::regclass);
ALTER TABLE ONLY public.invitations ALTER COLUMN id SET DEFAULT nextval('public.invitations_id_seq'::regclass);
ALTER TABLE ONLY public.matches ALTER COLUMN id SET DEFAULT nextval('public.matches_id_seq'::regclass);
ALTER TABLE ONLY public.mobilization_activists ALTER COLUMN id SET DEFAULT nextval('public.mobilization_activists_id_seq'::regclass);
ALTER TABLE ONLY public.mobilizations ALTER COLUMN id SET DEFAULT nextval('public.mobilizations_id_seq'::regclass);
ALTER TABLE ONLY public.notification_templates ALTER COLUMN id SET DEFAULT nextval('public.notification_templates_id_seq'::regclass);
ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);
ALTER TABLE ONLY public.payable_transfers ALTER COLUMN id SET DEFAULT nextval('public.payable_transfers_id_seq'::regclass);
ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);
ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);
ALTER TABLE ONLY public.plip_signatures ALTER COLUMN id SET DEFAULT nextval('public.plip_signatures_id_seq'::regclass);
ALTER TABLE ONLY public.plips ALTER COLUMN id SET DEFAULT nextval('public.plips_id_seq'::regclass);
ALTER TABLE ONLY public.plips_integration_logs ALTER COLUMN id SET DEFAULT nextval('public.plips_integration_logs_id_seq'::regclass);
ALTER TABLE ONLY public.pressures_integration_logs ALTER COLUMN id SET DEFAULT nextval('public.pressures_integration_logs_id_seq'::regclass);
ALTER TABLE ONLY public.recipients ALTER COLUMN id SET DEFAULT nextval('public.recipients_id_seq'::regclass);
ALTER TABLE ONLY public.schema_migrations ALTER COLUMN id SET DEFAULT nextval('public.schema_migrations_id_seq'::regclass);
ALTER TABLE ONLY public.solidarity_matches ALTER COLUMN id SET DEFAULT nextval('public.solidarity_matches_id_seq'::regclass);
ALTER TABLE ONLY public.solidarity_tickets ALTER COLUMN id SET DEFAULT nextval('public.solidarity_tickets_id_seq'::regclass);
ALTER TABLE ONLY public.solidarity_users ALTER COLUMN id SET DEFAULT nextval('public.solidarity_users_id_seq'::regclass);
ALTER TABLE ONLY public.solidarity_zd_tickets ALTER COLUMN id SET DEFAULT nextval('public.solidarity_zd_tickets_id_seq'::regclass);
ALTER TABLE ONLY public.subscription_transitions ALTER COLUMN id SET DEFAULT nextval('public.subscription_transitions_id_seq'::regclass);
ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);
ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);
ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);
ALTER TABLE ONLY public.template_blocks ALTER COLUMN id SET DEFAULT nextval('public.template_blocks_id_seq'::regclass);
ALTER TABLE ONLY public.template_mobilizations ALTER COLUMN id SET DEFAULT nextval('public.template_mobilizations_id_seq'::regclass);
ALTER TABLE ONLY public.template_widgets ALTER COLUMN id SET DEFAULT nextval('public.template_widgets_id_seq'::regclass);
ALTER TABLE ONLY public.twilio_call_transitions ALTER COLUMN id SET DEFAULT nextval('public.twilio_call_transitions_id_seq'::regclass);
ALTER TABLE ONLY public.twilio_calls ALTER COLUMN id SET DEFAULT nextval('public.twilio_calls_id_seq'::regclass);
ALTER TABLE ONLY public.twilio_configurations ALTER COLUMN id SET DEFAULT nextval('public.twilio_configurations_id_seq'::regclass);
ALTER TABLE ONLY public.user_tags ALTER COLUMN id SET DEFAULT nextval('public.user_tags_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
ALTER TABLE ONLY public.widgets ALTER COLUMN id SET DEFAULT nextval('public.widgets_id_seq'::regclass);
ALTER TABLE ONLY public.activist_actions
    ADD CONSTRAINT activist_actions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT activist_facebook_bot_interactions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT activist_matches_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT activist_pressures_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT activist_tags_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.activists
    ADD CONSTRAINT activists_email_key UNIQUE (email);
ALTER TABLE ONLY public.activists
    ADD CONSTRAINT activists_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.community_settings
    ADD CONSTRAINT app_settings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.balance_operations
    ADD CONSTRAINT balance_operations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.chatbot_campaigns
    ADD CONSTRAINT chatbot_campaigns_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.chatbot_interactions
    ADD CONSTRAINT chatbot_interactions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.chatbot_settings
    ADD CONSTRAINT chatbot_settings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.chatbots
    ADD CONSTRAINT chatbots_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT community_activists_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.community_settings
    ADD CONSTRAINT community_module_version_unique UNIQUE (name, version, community_id);
ALTER TABLE ONLY public.community_users
    ADD CONSTRAINT community_users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.community_users
    ADD CONSTRAINT community_users_unique UNIQUE (community_id, user_id, role);
ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.credit_cards
    ADD CONSTRAINT credit_cards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.dns_hosted_zones
    ADD CONSTRAINT dns_hosted_zones_domain_name_key UNIQUE (domain_name);
ALTER TABLE ONLY public.dns_hosted_zones
    ADD CONSTRAINT dns_hosted_zones_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.dns_records
    ADD CONSTRAINT dns_records_name_record_type_key UNIQUE (name, record_type);
ALTER TABLE ONLY public.dns_records
    ADD CONSTRAINT dns_records_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.donation_transitions
    ADD CONSTRAINT donation_transitions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.donations_integration_logs
    ADD CONSTRAINT donations_integration_logs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.facebook_bot_activists
    ADD CONSTRAINT facebook_bot_activists_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT facebook_bot_campaign_activists_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.facebook_bot_campaigns
    ADD CONSTRAINT facebook_bot_campaigns_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.facebook_bot_configurations
    ADD CONSTRAINT facebook_bot_configurations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT form_entries_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.forms_integration_logs
    ADD CONSTRAINT forms_integration_logs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.gateway_subscriptions
    ADD CONSTRAINT gateway_subscriptions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.gateway_transactions
    ADD CONSTRAINT gateway_transactions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.integrations_logs
    ADD CONSTRAINT integrations_logs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT mobilization_activists_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.payable_transfers
    ADD CONSTRAINT payable_transfers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.plip_signatures
    ADD CONSTRAINT plip_signatures_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.plips_integration_logs
    ADD CONSTRAINT plips_integration_logs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.plips
    ADD CONSTRAINT plips_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pressure_targets
    ADD CONSTRAINT pressure_targets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pressures_integration_logs
    ADD CONSTRAINT pressures_integration_logs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.recipients
    ADD CONSTRAINT recipients_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.rede_groups
    ADD CONSTRAINT rede_groups_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.rede_individuals
    ADD CONSTRAINT rede_individuals_form_entry_id UNIQUE (form_entry_id);
ALTER TABLE ONLY public.rede_individuals
    ADD CONSTRAINT rede_individuals_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.rede_relationships
    ADD CONSTRAINT rede_relationships_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_individuals_ticket_id_volunteers_ticket__key UNIQUE (individuals_ticket_id, volunteers_ticket_id);
ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.solidarity_tickets
    ADD CONSTRAINT solidarity_tickets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.solidarity_tickets
    ADD CONSTRAINT solidarity_tickets_ticket_id_key UNIQUE (ticket_id);
ALTER TABLE ONLY public.solidarity_users
    ADD CONSTRAINT solidarity_users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.solidarity_users
    ADD CONSTRAINT solidarity_users_user_id_key UNIQUE (user_id);
ALTER TABLE ONLY public.solidarity_zd_tickets
    ADD CONSTRAINT solidarity_zd_tickets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.solidarity_zd_tickets
    ADD CONSTRAINT solidarity_zd_tickets_ticket_id_key UNIQUE (ticket_id);
ALTER TABLE ONLY public.subscription_transitions
    ADD CONSTRAINT subscription_transitions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.template_blocks
    ADD CONSTRAINT template_blocks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.template_mobilizations
    ADD CONSTRAINT template_mobilizations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.template_widgets
    ADD CONSTRAINT template_widgets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.twilio_call_transitions
    ADD CONSTRAINT twilio_call_transitions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.twilio_calls
    ADD CONSTRAINT twilio_calls_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.twilio_configurations
    ADD CONSTRAINT twilio_configurations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pressure_targets
    ADD CONSTRAINT unique_identify_widget_id UNIQUE (widget_id, identify);
ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT user_tags_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.webhooks_registry
    ADD CONSTRAINT webhooks_registry_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);
CREATE INDEX cached_community_id_idx ON public.donations USING btree (cached_community_id);
CREATE INDEX donation_community_transaction_status_ids ON public.donations USING btree (cached_community_id, transaction_status);
CREATE INDEX ids_blocks_mob_id ON public.blocks USING btree (mobilization_id);
CREATE INDEX ids_widgets_block_id ON public.widgets USING btree (block_id);
CREATE INDEX ids_widgets_kind ON public.widgets USING btree (kind);
CREATE INDEX idx_activist_actions_activist_id ON public.activist_actions USING btree (activist_id);
CREATE INDEX idx_activist_actions_community_id ON public.activist_actions USING btree (community_id);
CREATE INDEX idx_activist_actions_mobilization_id ON public.activist_actions USING btree (mobilization_id);
CREATE INDEX idx_activist_actions_widget_id ON public.activist_actions USING btree (widget_id);
CREATE INDEX idx_activists_on_bot_interations ON public.activist_facebook_bot_interactions USING btree (activist_id);
CREATE INDEX idx_bot_config_on_bot_interactions ON public.activist_facebook_bot_interactions USING btree (facebook_bot_configuration_id);
CREATE INDEX idx_facebook_bot_campaign_activists_on_facebook_bot_activist_id ON public.facebook_bot_campaign_activists USING btree (facebook_bot_activist_id);
CREATE INDEX idx_facebook_bot_campaign_activists_on_facebook_bot_campaign_id ON public.facebook_bot_campaign_activists USING btree (facebook_bot_campaign_id);
CREATE INDEX idx_form_entries_activist_id ON public.form_entries USING btree (activist_id);
CREATE INDEX idx_mobilizations_custom_domain ON public.mobilizations USING btree (custom_domain);
CREATE INDEX idx_mobilizations_slug ON public.mobilizations USING btree (slug);
CREATE INDEX index_activist_matches_on_activist_id ON public.activist_matches USING btree (activist_id);
CREATE INDEX index_activist_matches_on_match_id ON public.activist_matches USING btree (match_id);
CREATE INDEX index_activist_pressures_on_activist_id ON public.activist_pressures USING btree (activist_id);
CREATE INDEX index_activist_pressures_on_widget_id ON public.activist_pressures USING btree (widget_id);
CREATE UNIQUE INDEX index_activist_tags_on_activist_id_and_community_id_and_mob_id ON public.activist_tags USING btree (activist_id, community_id, mobilization_id);
CREATE INDEX index_activists_on_created_at ON public.activists USING btree (created_at DESC);
CREATE INDEX index_activists_on_email ON public.activists USING btree (email);
CREATE INDEX index_addresses_on_activist_id ON public.addresses USING btree (activist_id);
CREATE INDEX index_balance_operations_on_recipient_id ON public.balance_operations USING btree (recipient_id);
CREATE INDEX index_community_activists_on_activist_id ON public.community_activists USING btree (activist_id);
CREATE INDEX index_community_activists_on_community_id ON public.community_activists USING btree (community_id);
CREATE UNIQUE INDEX index_community_activists_on_community_id_and_activist_id ON public.community_activists USING btree (community_id, activist_id);
CREATE UNIQUE INDEX index_configurations_on_name ON public.configurations USING btree (name);
CREATE INDEX index_credit_cards_on_activist_id ON public.credit_cards USING btree (activist_id);
CREATE UNIQUE INDEX index_dns_hosted_zones_on_domain_name ON public.dns_hosted_zones USING btree (domain_name);
CREATE UNIQUE INDEX index_dns_records_on_name_and_record_type ON public.dns_records USING btree (name, record_type);
CREATE UNIQUE INDEX index_donation_transitions_parent_most_recent ON public.donation_transitions USING btree (donation_id, most_recent) WHERE most_recent;
CREATE UNIQUE INDEX index_donation_transitions_parent_sort ON public.donation_transitions USING btree (donation_id, sort_key);
CREATE INDEX index_donations_on_activist_id ON public.donations USING btree (activist_id);
CREATE INDEX index_donations_on_customer ON public.donations USING gin (customer);
CREATE INDEX index_donations_on_payable_transfer_id ON public.donations USING btree (payable_transfer_id);
CREATE UNIQUE INDEX index_donations_on_transaction_id ON public.donations USING btree (transaction_id);
CREATE INDEX index_donations_on_widget_id ON public.donations USING btree (widget_id);
CREATE INDEX index_facebook_bot_activists_on_messages ON public.facebook_bot_activists USING gin (messages);
CREATE INDEX index_facebook_bot_activists_on_quick_replies ON public.facebook_bot_activists USING btree (quick_replies);
CREATE UNIQUE INDEX index_facebook_bot_activists_on_recipient_id_and_sender_id ON public.facebook_bot_activists USING btree (fb_context_recipient_id, fb_context_sender_id);
CREATE INDEX index_facebook_bot_campaigns_on_facebook_bot_configuration_id ON public.facebook_bot_campaigns USING btree (facebook_bot_configuration_id);
CREATE INDEX index_form_entries_on_widget_id ON public.form_entries USING btree (widget_id);
CREATE UNIQUE INDEX index_gateway_subscriptions_on_subscription_id ON public.gateway_subscriptions USING btree (subscription_id);
CREATE UNIQUE INDEX index_invitations_on_community_id_and_code ON public.invitations USING btree (community_id, code);
CREATE INDEX index_matches_on_widget_id ON public.matches USING btree (widget_id);
CREATE INDEX index_mobilization_activists_on_activist_id ON public.mobilization_activists USING btree (activist_id);
CREATE INDEX index_mobilization_activists_on_mobilization_id ON public.mobilization_activists USING btree (mobilization_id);
CREATE UNIQUE INDEX index_mobilization_activists_on_mobilization_id_and_activist_id ON public.mobilization_activists USING btree (mobilization_id, activist_id);
CREATE INDEX index_mobilizations_on_community_id ON public.mobilizations USING btree (community_id);
CREATE UNIQUE INDEX index_mobilizations_on_custom_domain ON public.mobilizations USING btree (custom_domain);
CREATE UNIQUE INDEX index_mobilizations_on_slug ON public.mobilizations USING btree (slug);
CREATE INDEX index_notifications_on_activist_id ON public.notifications USING btree (activist_id);
CREATE INDEX index_notifications_on_community_id ON public.notifications USING btree (community_id);
CREATE INDEX index_notifications_on_notification_template_id ON public.notifications USING btree (notification_template_id);
CREATE INDEX index_payments_on_donation_id ON public.payments USING btree (donation_id);
CREATE UNIQUE INDEX index_subscription_transitions_parent_most_recent ON public.subscription_transitions USING btree (subscription_id, most_recent) WHERE most_recent;
CREATE UNIQUE INDEX index_subscription_transitions_parent_sort ON public.subscription_transitions USING btree (subscription_id, sort_key);
CREATE INDEX index_subscriptions_on_activist_id ON public.subscriptions USING btree (activist_id);
CREATE INDEX index_subscriptions_on_community_id ON public.subscriptions USING btree (community_id);
CREATE INDEX index_subscriptions_on_widget_id ON public.subscriptions USING btree (widget_id);
CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);
CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);
CREATE INDEX index_taggings_on_taggable_id ON public.taggings USING btree (taggable_id);
CREATE INDEX index_taggings_on_taggable_id_and_taggable_type ON public.taggings USING btree (taggable_id, taggable_type);
CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);
CREATE INDEX index_taggings_on_taggable_type ON public.taggings USING btree (taggable_type);
CREATE INDEX index_taggings_on_tagger_id ON public.taggings USING btree (tagger_id);
CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON public.taggings USING btree (tagger_id, tagger_type);
CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);
CREATE INDEX index_twilio_calls_on_widget_id ON public.twilio_calls USING btree (widget_id);
CREATE UNIQUE INDEX index_twilio_configurations_on_community_id ON public.twilio_configurations USING btree (community_id);
CREATE INDEX index_user_tags_on_user_id ON public.user_tags USING btree (user_id);
CREATE INDEX index_users_on_email ON public.users USING btree (email);
CREATE UNIQUE INDEX index_users_on_uid_and_provider ON public.users USING btree (uid, provider);
CREATE INDEX local_subs_id_idx ON public.donations USING btree (local_subscription_id);
CREATE UNIQUE INDEX notification_templates_label_uniq_idx ON public.notification_templates USING btree (community_id, label, locale);
CREATE INDEX ordasc_widgets ON public.widgets USING btree (id);
CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);
CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);
CREATE UNIQUE INDEX uniq_email_acts ON public.activists USING btree (lower(((email)::public.email)::text));
CREATE UNIQUE INDEX uniq_m_page_access_token_idx ON public.facebook_bot_configurations USING btree (messenger_page_access_token);
CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);
CREATE OR REPLACE VIEW public.activist_participations AS
 SELECT c.id AS community_id,
    m.id AS mobilization_id,
    w.id AS widget_id,
    a.id AS activist_id,
    a.email,
    COALESCE(fe.created_at, d.created_at, ap.created_at, s.created_at) AS participate_at,
        CASE
            WHEN (fe.id IS NOT NULL) THEN 'form_entry'::text
            WHEN ((d.id IS NOT NULL) AND (d.local_subscription_id IS NOT NULL)) THEN 'subscription'::text
            WHEN ((d.id IS NOT NULL) AND (d.local_subscription_id IS NULL)) THEN 'donation'::text
            WHEN (ap.id IS NOT NULL) THEN 'activist_pressure'::text
            WHEN (s.id IS NOT NULL) THEN 'subscription'::text
            ELSE NULL::text
        END AS participate_kind,
    COALESCE(fe.id, d.id, ap.id, s.id) AS participate_id
   FROM ((((((((public.communities c
     JOIN public.mobilizations m ON ((m.community_id = c.id)))
     LEFT JOIN public.blocks b ON ((b.mobilization_id = m.id)))
     LEFT JOIN public.widgets w ON ((w.block_id = b.id)))
     LEFT JOIN public.form_entries fe ON ((fe.widget_id = w.id)))
     LEFT JOIN public.donations d ON (((d.widget_id = w.id) AND (NOT d.subscription))))
     LEFT JOIN public.subscriptions s ON ((s.widget_id = w.id)))
     LEFT JOIN public.activist_pressures ap ON ((ap.widget_id = w.id)))
     JOIN public.activists a ON ((a.id = COALESCE(fe.activist_id, d.activist_id, s.activist_id, ap.activist_id))))
  GROUP BY c.id, m.id, w.id, a.id, fe.id, s.id, ap.id, d.id, fe.created_at, s.created_at, ap.created_at, d.created_at;
CREATE OR REPLACE VIEW public.agg_activists AS
 SELECT com.id AS community_id,
    a.id AS activist_id,
    a.email,
    a.name,
    agg_fe.count AS total_form_entries
   FROM ((((public.communities com
     JOIN public.community_activists cac ON ((cac.community_id = com.id)))
     JOIN public.activists a ON ((a.id = cac.activist_id)))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM (((public.form_entries fe
             JOIN public.widgets w ON ((w.id = fe.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((b.mobilization_id = m.id)))
          WHERE ((fe.activist_id = a.id) AND (m.community_id = com.id))) agg_fe ON (true))
     LEFT JOIN LATERAL ( SELECT (btrim((d2.customer OPERATOR(public.->) 'address'::text), '{}'::text))::public.hstore AS address
           FROM public.donations d2
          WHERE ((d2.activist_id = a.id) AND (d2.transaction_id IS NOT NULL) AND (d2.transaction_status IS NOT NULL) AND (d2.customer IS NOT NULL))
          ORDER BY d2.id DESC
         LIMIT 1) last_customer ON (true))
  WHERE (a.id IS NOT NULL)
  GROUP BY com.id, a.email, a.id, last_customer.address, agg_fe.count;
CREATE OR REPLACE VIEW public.participations AS
 SELECT c.id AS community_id,
    m.id AS mobilization_id,
    w.id AS widget_id,
    a.id AS activist_id,
    a.email,
    COALESCE(fe.created_at, d.created_at, ap.created_at, s.created_at) AS participate_at,
        CASE
            WHEN (fe.id IS NOT NULL) THEN 'form_entry'::text
            WHEN ((d.id IS NOT NULL) AND (d.local_subscription_id IS NOT NULL)) THEN 'subscription'::text
            WHEN ((d.id IS NOT NULL) AND (d.local_subscription_id IS NULL)) THEN 'donation'::text
            WHEN (ap.id IS NOT NULL) THEN 'activist_pressure'::text
            WHEN (s.id IS NOT NULL) THEN 'subscription'::text
            ELSE NULL::text
        END AS participate_kind,
    COALESCE(fe.id, d.id, ap.id, s.id) AS participate_id
   FROM ((((((((public.communities c
     JOIN public.mobilizations m ON ((m.community_id = c.id)))
     LEFT JOIN public.blocks b ON ((b.mobilization_id = m.id)))
     LEFT JOIN public.widgets w ON ((w.block_id = b.id)))
     LEFT JOIN public.form_entries fe ON ((fe.widget_id = w.id)))
     LEFT JOIN public.donations d ON (((d.widget_id = w.id) AND (NOT d.subscription))))
     LEFT JOIN public.subscriptions s ON ((s.widget_id = w.id)))
     LEFT JOIN public.activist_pressures ap ON ((ap.widget_id = w.id)))
     JOIN public.activists a ON ((a.id = COALESCE(fe.activist_id, d.activist_id, s.activist_id, ap.activist_id))))
  GROUP BY c.id, m.id, w.id, a.id, fe.id, s.id, ap.id, d.id, fe.created_at, s.created_at, ap.created_at, d.created_at;
CREATE TRIGGER activist_pressures_update_at BEFORE UPDATE ON public.activist_pressures FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER activists_update_at BEFORE UPDATE ON public.activists FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER chatbots_campaigns_update_at BEFORE UPDATE ON public.chatbot_campaigns FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER chatbots_interactions_update_at BEFORE UPDATE ON public.chatbot_interactions FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER chatbots_settings_update_at BEFORE UPDATE ON public.chatbot_settings FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER chatbots_update_at BEFORE UPDATE ON public.chatbots FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER community_users_update_at BEFORE UPDATE ON public.community_users FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER dns_hosted_zones_update_at BEFORE UPDATE ON public.dns_hosted_zones FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER dns_records_update_at BEFORE UPDATE ON public.dns_records FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER donations_update_at BEFORE UPDATE ON public.donations FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.activist_pressures FOR EACH ROW EXECUTE FUNCTION public.generate_activists_from_generic_resource_with_widget();
CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.donations FOR EACH ROW EXECUTE FUNCTION public.generate_activists_from_generic_resource_with_widget();
CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.form_entries FOR EACH ROW EXECUTE FUNCTION public.generate_activists_from_generic_resource_with_widget();
CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.generate_activists_from_generic_resource_with_widget();
CREATE TRIGGER invitations_update_at BEFORE UPDATE ON public.invitations FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER invitations_update_expires BEFORE INSERT ON public.invitations FOR EACH ROW EXECUTE FUNCTION public.update_expires();
CREATE TRIGGER pressure_targets_update_at BEFORE UPDATE ON public.pressure_targets FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER recipients_update_at BEFORE UPDATE ON public.recipients FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER rede_groups_update_at BEFORE UPDATE ON public.rede_groups FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER rede_individuals_update_at BEFORE UPDATE ON public.rede_individuals FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER rede_relationships_update_at BEFORE UPDATE ON public.rede_relationships FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER set_public_plips_updated_at BEFORE UPDATE ON public.plips FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_plips_updated_at ON public.plips IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER trig_copy_activist_pressures AFTER INSERT ON public.activist_pressures FOR EACH ROW EXECUTE FUNCTION public.copy_activist_pressures();
CREATE TRIGGER trig_copy_donations AFTER INSERT ON public.donations FOR EACH ROW EXECUTE FUNCTION public.copy_donations();
CREATE TRIGGER update_facebook_bot_activist_data AFTER INSERT OR UPDATE ON public.activist_facebook_bot_interactions FOR EACH ROW EXECUTE FUNCTION public.update_facebook_bot_activists_full_text_index();
CREATE TRIGGER user_tags_update_at BEFORE UPDATE ON public.user_tags FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER users_update_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.updated_at_column();
CREATE TRIGGER watched_create_form_entries_trigger AFTER INSERT OR UPDATE ON public.form_entries FOR EACH ROW WHEN ((new.widget_id = ANY (ARRAY[16850, 17628, 17633]))) EXECUTE FUNCTION public.notify_form_entries_trigger();
CREATE TRIGGER watched_create_twilio_configuration_trigger AFTER INSERT OR UPDATE ON public.twilio_configurations FOR EACH ROW EXECUTE FUNCTION public.notify_create_twilio_configuration_trigger();
CREATE TRIGGER watched_twilio_call_trigger AFTER INSERT ON public.twilio_calls FOR EACH ROW EXECUTE FUNCTION public.notify_twilio_call_trigger();
ALTER TABLE ONLY public.activist_actions
    ADD CONSTRAINT activist_actions_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.activist_actions
    ADD CONSTRAINT activist_actions_mobilization_id_fkey FOREIGN KEY (mobilization_id) REFERENCES public.mobilizations(id);
ALTER TABLE ONLY public.activist_actions
    ADD CONSTRAINT activist_actions_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.chatbot_campaigns
    ADD CONSTRAINT chatbot_campaigns_chatbot_id_fkey FOREIGN KEY (chatbot_id) REFERENCES public.chatbots(id);
ALTER TABLE ONLY public.chatbot_interactions
    ADD CONSTRAINT chatbot_interactions_chatbot_id_fkey FOREIGN KEY (chatbot_id) REFERENCES public.chatbots(id);
ALTER TABLE ONLY public.chatbot_settings
    ADD CONSTRAINT chatbot_settings_chatbot_id_fkey FOREIGN KEY (chatbot_id) REFERENCES public.chatbots(id);
ALTER TABLE ONLY public.chatbots
    ADD CONSTRAINT chatbots_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.community_settings
    ADD CONSTRAINT community_id_foreign_key FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.donations_integration_logs
    ADD CONSTRAINT donations_integration_logs_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.donations_integration_logs
    ADD CONSTRAINT donations_integration_logs_donation_id_fkey FOREIGN KEY (donation_id) REFERENCES public.donations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.donations_integration_logs
    ADD CONSTRAINT donations_integration_logs_integrations_id_fkey FOREIGN KEY (integration_id) REFERENCES public.integrations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.donations_integration_logs
    ADD CONSTRAINT donations_integration_logs_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.pressure_targets
    ADD CONSTRAINT fk_pressure_targets_widget FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT fk_rails_015164fe8d FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT fk_rails_0786dde5c3 FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_0ded3585f1 FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT fk_rails_0ff272a657 FOREIGN KEY (facebook_bot_activist_id) REFERENCES public.facebook_bot_activists(id);
ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT fk_rails_26ca62b2d0 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_2fb35253bd FOREIGN KEY (notification_template_id) REFERENCES public.notification_templates(id);
ALTER TABLE ONLY public.recipients
    ADD CONSTRAINT fk_rails_35bdfe7f89 FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_3bd353c401 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_3ff765ac30 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT fk_rails_4d2ba73b48 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_4ea5195391 FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.matches
    ADD CONSTRAINT fk_rails_5238d1bbc9 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_61f00b3de3 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT fk_rails_64d1e99667 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_67eb37c69b FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT fk_rails_6ed0c7457d FOREIGN KEY (facebook_bot_campaign_id) REFERENCES public.facebook_bot_campaigns(id);
ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_7217bc1bdf FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT fk_rails_7701a28e7f FOREIGN KEY (match_id) REFERENCES public.matches(id);
ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_7e28014775 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT fk_rails_821106ac31 FOREIGN KEY (mobilization_id) REFERENCES public.mobilizations(id);
ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT fk_rails_8229429c26 FOREIGN KEY (facebook_bot_configuration_id) REFERENCES public.facebook_bot_configurations(id);
ALTER TABLE ONLY public.twilio_calls
    ADD CONSTRAINT fk_rails_8329ec7002 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_893eb4f32e FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_920c5d67ae FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_9279978f7a FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_98e396f4c1 FOREIGN KEY (local_subscription_id) REFERENCES public.subscriptions(id);
ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT fk_rails_9c54902f75 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT fk_rails_a007365593 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_a268b06370 FOREIGN KEY (recipient_id) REFERENCES public.recipients(id);
ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_aaa30ab12e FOREIGN KEY (payable_transfer_id) REFERENCES public.payable_transfers(id);
ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_b080fb4855 FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT fk_rails_b2d73f1a99 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.facebook_bot_campaigns
    ADD CONSTRAINT fk_rails_b518e26154 FOREIGN KEY (facebook_bot_configuration_id) REFERENCES public.facebook_bot_configurations(id);
ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_c1941efec9 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.dns_hosted_zones
    ADD CONSTRAINT fk_rails_c6b1f8b17a FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_c70c9be1c0 FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_cbe3790222 FOREIGN KEY (activist_id) REFERENCES public.activists(id);
ALTER TABLE ONLY public.dns_records
    ADD CONSTRAINT fk_rails_ce2c3e0b71 FOREIGN KEY (dns_hosted_zone_id) REFERENCES public.dns_hosted_zones(id);
ALTER TABLE ONLY public.balance_operations
    ADD CONSTRAINT fk_rails_cee230e2a2 FOREIGN KEY (recipient_id) REFERENCES public.recipients(id);
ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_db28a0ad48 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT fk_rails_e8fa6ecb6c FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT fk_rails_ea0382482a FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT fk_rails_fa4f63f07b FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.forms_integration_logs
    ADD CONSTRAINT forms_integration_logs_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.forms_integration_logs
    ADD CONSTRAINT forms_integration_logs_form_entry_id_fkey FOREIGN KEY (form_entry_id) REFERENCES public.form_entries(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.forms_integration_logs
    ADD CONSTRAINT forms_integration_logs_integrations_id_fkey FOREIGN KEY (integration_id) REFERENCES public.integrations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.forms_integration_logs
    ADD CONSTRAINT forms_integration_logs_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT gateway_subscription_fk FOREIGN KEY (gateway_subscription_id) REFERENCES public.gateway_subscriptions(id);
ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.integrations_logs
    ADD CONSTRAINT integrations_logs_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.integrations_logs
    ADD CONSTRAINT integrations_logs_integrations_id_fkey FOREIGN KEY (integration_id) REFERENCES public.integrations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.integrations_logs
    ADD CONSTRAINT integrations_logs_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_subtheme_primary_fkey FOREIGN KEY (subtheme_primary) REFERENCES postgraphql.mobilizations_subthemes(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_subtheme_secondary_fkey FOREIGN KEY (subtheme_secondary) REFERENCES postgraphql.mobilizations_subthemes(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_subtheme_tertiary_fkey FOREIGN KEY (subtheme_tertiary) REFERENCES postgraphql.mobilizations_subthemes(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_theme_fkey FOREIGN KEY (theme) REFERENCES postgraphql.mobilizations_themes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.plip_signatures
    ADD CONSTRAINT plip_signatures_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.plip_signatures
    ADD CONSTRAINT plip_signatures_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.plips_integration_logs
    ADD CONSTRAINT plips_integration_logs_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.plips_integration_logs
    ADD CONSTRAINT plips_integration_logs_integrations_id_fkey FOREIGN KEY (integration_id) REFERENCES public.integrations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.plips_integration_logs
    ADD CONSTRAINT plips_integration_logs_plip_id_fkey FOREIGN KEY (plip_id) REFERENCES public.plips(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.plips_integration_logs
    ADD CONSTRAINT plips_integration_logs_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.plips
    ADD CONSTRAINT plips_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.pressures_integration_logs
    ADD CONSTRAINT pressures_integration_logs_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.pressures_integration_logs
    ADD CONSTRAINT pressures_integration_logs_integrations_id_fkey FOREIGN KEY (integration_id) REFERENCES public.integrations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.pressures_integration_logs
    ADD CONSTRAINT pressures_integration_logs_pressure_id_fkey FOREIGN KEY (pressure_id) REFERENCES public.activist_pressures(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.pressures_integration_logs
    ADD CONSTRAINT pressures_integration_logs_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.rede_groups
    ADD CONSTRAINT rede_groups_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.rede_groups
    ADD CONSTRAINT rede_groups_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id);
ALTER TABLE ONLY public.rede_individuals
    ADD CONSTRAINT rede_individuals_form_entry_id_fkey FOREIGN KEY (form_entry_id) REFERENCES public.form_entries(id);
ALTER TABLE ONLY public.rede_individuals
    ADD CONSTRAINT rede_individuals_rede_group_id_fkey FOREIGN KEY (rede_group_id) REFERENCES public.rede_groups(id);
ALTER TABLE ONLY public.rede_relationships
    ADD CONSTRAINT rede_relationships_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.rede_individuals(id);
ALTER TABLE ONLY public.rede_relationships
    ADD CONSTRAINT rede_relationships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE ONLY public.rede_relationships
    ADD CONSTRAINT rede_relationships_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.rede_individuals(id);
ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_individuals_ticket_id_fkey FOREIGN KEY (individuals_ticket_id) REFERENCES public.solidarity_tickets(ticket_id);
ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_individuals_user_id_fkey FOREIGN KEY (individuals_user_id) REFERENCES public.solidarity_users(user_id);
ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_volunteers_ticket_id_fkey FOREIGN KEY (volunteers_ticket_id) REFERENCES public.solidarity_tickets(ticket_id);
ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_volunteers_user_id_fkey FOREIGN KEY (volunteers_user_id) REFERENCES public.solidarity_users(user_id);
ALTER TABLE ONLY public.solidarity_tickets
    ADD CONSTRAINT solidarity_tickets_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);
ALTER TABLE ONLY public.solidarity_users
    ADD CONSTRAINT solidarity_users_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);
