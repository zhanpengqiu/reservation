-- Add up migration script here

CREATE OR REPLACE FUNCTION rsvp.query(uid text, rid text, during TSTZRANGE) RETURNS TABLE (LIKE rsvp.reservations)
AS $$ 
BEGIN
    -- if both are null, find all reservations within during
    IF uid IS NULL AND rid IS NULL THEN
        RETURN QUERY SELECT * FROM rsvp.reservations WHERE during && timespan;
   -- if user_id is null, find all reservations within during for the resource
    ELSIF uid IS NULL THEN
        RETURN QUERY SELECT * FROM rsvp.reservations WHERE resource_id = rid AND during @> timespan;
    -- if resource_id is null, find all reservations within during for the user
    ELSIF rid IS NULL THEN
        RETURN QUERY SELECT * FROM rsvp.reservations WHERE user_id= uid AND during @> timespan;
    -- if both set, find all reservations within during for the resource and user
    ELSE
        RETURN QUERY SELECT * FROM rsvp.reservations WHERE resource_id=rid AND user_id=uid AND during @> timespan;
    END IF;                         
END;
$$ LANGUAGE plpgsql;