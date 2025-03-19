rec {
  mkTrigger =
    entity_id: args:
    (
      args
      // {
        inherit entity_id;
      }
    );

  mkTypeTrigger =
    trigger: entity_id: args:
    mkTrigger entity_id (args // { inherit trigger; });

  mkStateTrigger = mkTypeTrigger "state";

  mkPlatformTrigger =
    platform: entity_id: args:
    mkTrigger entity_id (
      args
      // {
        inherit platform;
      }
    );

  mkZoneTrigger =
    entity_id: zone: event:
    mkPlatformTrigger "zone" entity_id {
      inherit zone event;
    };

  mkCondition =
    condition: args:
    (
      args
      // {
        inherit condition;
      }
    );

  mkTemplateCondition =
    value_template:
    mkCondition "template" {
      inherit value_template;
    };

  mkAndCondition =
    conditions:
    mkCondition "and" {
      inherit conditions;
    };

  mkOrCondition =
    conditions:
    mkCondition "or" {
      inherit conditions;
    };

  mkNotCondition =
    conditions:
    mkCondition "not" {
      inherit conditions;
    };

  mkNumericStateCondition =
    entity_id: args:
    mkCondition "numeric_state" (
      args
      // {
        inherit entity_id;
      }
    );

  mkStateCondition =
    entity_id: state: args:
    mkCondition "state" (
      args
      // {
        inherit entity_id state;
      }
    );

  mkSunCondition = mkCondition "sun";

  mkTimeCondition = mkCondition "time";

  mkTriggerCondition =
    id: args:
    mkCondition "trigger" (
      args
      // {
        inherit id;
      }
    );

  mkZoneCondition =
    entity_id: zone: args:
    mkCondition "zone" (
      args
      // {
        inherit entity_id zone;
      }
    );

  mkAction =
    action: args:
    (
      args
      // {
        inherit action;
      }
    );
}
