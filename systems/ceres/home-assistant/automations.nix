{lib, ...}: let
  mkGeolocationTrigger = {
    actor_id,
    target_id,
    zone ? "zone.home",
  }: {
    automation = [
      {
        alias = "Geolocation/When ${actor_id} leaves ${zone} then switch ${target_id} off";
        trigger = [
          {
            platform = "zone";
            entity_id = actor_id;
            inherit zone;
            event = "leave";
          }
        ];
        action = [
          {
            action = "switch.turn_off";
            target.entity_id = target_id;
          }
        ];
      }
      {
        alias = "Geolocation/When ${actor_id} enters ${zone} then switch ${target_id} on";
        trigger = [
          {
            platform = "zone";
            entity_id = actor_id;
            inherit zone;
            event = "enter";
          }
        ];
        action = [
          {
            action = "switch.turn_on";
            target.entity_id = target_id;
          }
        ];
      }
    ];
  };

  mkVacuumTrigger = {
    actor_id,
    zone ? "zone.home",
    roomba_id,
  }: let
    input_id = "${lib.removePrefix "vacuum." roomba_id}_last_clean";
  in {
    input_datetime."${input_id}" = {
      name = "Vacuum ${roomba_id}'s Last Clean";
      has_date = true;
      has_time = true;
    };

    automation = [
      {
        alias = "Vacuum/When ${actor_id} leaves ${zone} then trigger ${roomba_id}";
        trigger = [
          {
            platform = "zone";
            entity_id = actor_id;
            inherit zone;
            event = "leave";
          }
        ];
        condition = [
          {
            condition = "and";
            conditions = [
              {
                condition = "template";
                value_template = let
                  days = 3;
                in "{{ (states.input_datetime.${input_id}.attributes.timestamp - as_timestamp(now())) | abs > (60 * 60 * 24 * ${toString days}) }}";
              }
              {
                condition = "time";
                after = "09:00:00";
                before = "22:00:00";
              }
            ];
          }
        ];
        action = [
          {
            action = "vacuum.start";
            target.entity_id = roomba_id;
          }
        ];
      }
      {
        alias = "Vacuum/When ${roomba_id} starts cleaning then set input_datetime.${input_id}";
        trigger = [
          {
            trigger = "state";
            entity_id = [
              roomba_id
            ];
            to = "cleaning";
          }
        ];
        action = [
          {
            action = "input_datetime.set_datetime";
            target.entity_id = "input_datetime.${input_id}";
            data.datetime = "{{ now() }}";
          }
        ];
      }
    ];
  };

  mkTimer = {
    at,
    name ? "unknown",
    conditions ? [],
    actions,
  }: {
    automation = [
      {
        alias = "Timer/At ${at}, trigger ${name}";

        triggers = [
          {
            trigger = "time";
            inherit at;
          }
        ];

        inherit conditions actions;
      }
    ];
  };

  mkBlindTimer = {
    event,
    entity_id,
    action,
    offset ? "00:00:00",
  }: {
    automation = [
      {
        alias = "Timer/On ${event}, trigger ${lib.concatStringsSep ", " entity_id}";

        triggers = [
          {
            trigger = "sun";
            inherit event offset;
          }
        ];

        actions = [
          {
            inherit action;
            target = {
              inherit entity_id;
            };
          }
        ];
      }
    ];
  };
in
  lib.mkMerge [
    {
      cover = [
        {
          platform = "group";
          name = "Rolgordijn beneden";
          entities = [
            "cover.rollerblind_0001"
            "cover.rollerblind_0002"
          ];
        }
      ];

      media_player = [
        {
          platform = "group";
          name = "Speakers";
          entities = [
            "media_player.badkamer"
            "media_player.eetkamer"
            "media_player.slaapkamer_anke"
            "media_player.slaapkamer_stijn"
          ];
        }
      ];

      script.announce = {
        alias = "Announce";

        fields.message = {
          name = "Message";
          required = true;
        };

        sequence = [
          {
            action = "tts.speak";
            data = {
              cache = true;
              message = "{{ message }}";
              media_player_entity_id = "media_player.speakers";
            };
            target.entity_id = "tts.elevenlabs";
          }
        ];
      };
    }
    {
      input_text."intercom_value" = {
        name = "Intercom bericht";
      };
    }
    (mkGeolocationTrigger {
      actor_id = "person.bddvlpr";
      target_id = "switch.stijnifttt";
    })
    (mkGeolocationTrigger {
      actor_id = "person.sven";
      target_id = "switch.svenifttt";
    })
    (mkGeolocationTrigger {
      actor_id = "person.cin";
      target_id = "switch.cinifttt";
    })
    (mkGeolocationTrigger {
      actor_id = "person.anke";
      target_id = "switch.ankeifttt";
    })
    (mkVacuumTrigger {
      actor_id = "person.bddvlpr";
      roomba_id = "vacuum.roomba_691";
    })
    (mkTimer {
      at = "01:00:00";
      name = "Salon RGBW";
      actions = [
        {
          action = "light.turn_off";
          target.entity_id = "light.led_strip_rgbw_light_0";
        }
      ];
    })
    (mkBlindTimer {
      event = "sunrise";
      action = "cover.open_cover";
      entity_id = [
        "cover.rollerblind_0001"
        "cover.rollerblind_0002"
      ];
    })
    (mkBlindTimer {
      event = "sunset";
      action = "cover.close_cover";
      entity_id = [
        "cover.rollerblind_0001"
        "cover.rollerblind_0002"
      ];
    })
  ]
