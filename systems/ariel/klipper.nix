{
  services.klipper = {
    enable = true;

    user = "moonraker";
    group = "moonraker";

    settings = {
      stepper_x = {
        step_pin = "PC2";
        dir_pin = "PB9";
        enable_pin = "!PC3";
        microsteps = 16;
        rotation_distance = 40;
        endstop_pin = "^PA5";
        position_endstop = 0;
        position_max = 235;
        homing_speed = 80;
      };

      stepper_y = {
        step_pin = "PB8";
        dir_pin = "PB7";
        enable_pin = "!PC3";
        microsteps = 16;
        rotation_distance = 40;
        endstop_pin = "^PA6";
        position_endstop = 0;
        position_max = 235;
        homing_speed = 80;
      };

      stepper_z = {
        step_pin = "PB6";
        dir_pin = "!PB5";
        enable_pin = "!PC3";
        microsteps = 16;
        rotation_distance = 8;
        endstop_pin = "probe:z_virtual_endstop";
        position_max = 230;
        position_min = -5;
        homing_speed = 4;
        second_homing_speed = 1;
        homing_retract_dist = 2.0;
      };

      extruder = {
        max_extrude_only_distance = 100.0;
        step_pin = "PB4";
        dir_pin = "PB3";
        enable_pin = "!PC3";
        microsteps = 16;
        gear_ratio = "3.5:1";
        rotation_distance = 25.52108;
        nozzle_diameter = 0.400;
        filament_diameter = 1.750;
        heater_pin = "PA1";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "PC5";
        control = "pid";
        pid_Kp = 21.527;
        pid_Ki = 1.063;
        pid_Kd = 108.982;
        min_temp = 0;
        max_temp = 250;
      };
      heater_bed = {
        heater_pin = "PA2";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "PC4";
        control = "pid";
        pid_kp = 70.405;
        pid_ki = 1.229;
        pid_kd = 1008.553;
        min_temp = 0;
        max_temp = 130;
      };

      fan = {
        pin = "PA0";
      };

      mcu = {
        serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
        restart_method = "command";
      };

      printer = {
        kinematics = "cartesian";
        max_velocity = 300;
        max_accel = 5000;
        max_z_velocity = 5;
        square_corner_velocity = 5.0;
        max_z_accel = 100;
      };

      bltouch = {
        sensor_pin = "^PB1";
        control_pin = "PB0";
        x_offset = -45.0;
        y_offset = -10.0;
        z_offset = 0;
        speed = 20;
        samples = 1;
        sample_retract_dist = 8.0;
      };

      safe_z_home = {
        home_xy_position = "160,120";
        speed = 150;
        z_hop = 10;
        z_hop_speed = 10;
      };

      bed_mesh = {
        speed = 120;
        mesh_min = "30,30";
        mesh_max = "189,189";
        probe_count = "5,5";
        fade_start = 1;
        fade_end = 10;
        fade_target = 0;
        algorithm = "bicubic";
      };

      bed_screws = {
        screw1 = "30,25";
        screw1_name = 1;
        screw2 = "200,25";
        screw2_name = 2;
        screw3 = "200,195";
        screw3_name = 3;
        screw4 = "30,195";
        screw4_name = 4;
      };

      screws_tilt_adjust = {
        screw1 = "67, 42";
        screw1_name = "front left screw";
        screw2 = "237.60, 42";
        screw2_name = "front right screw";
        screw3 = "237.60, 212";
        screw3_name = "rear right screw";
        screw4 = "67.60, 212";
        screw4_name = "rear left screw";
        horizontal_move_z = 10;
        speed = 200;
        screw_thread = "CW-M4";
      };

      "output_pin beeper" = {
        pin = "PB13";
      };
    };

    firmwares = {
      mcu = {
        enable = true;
        serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
        configFile = ./printer/mcu.cfg;
      };
    };
  };
}
