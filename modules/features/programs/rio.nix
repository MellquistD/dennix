{
  self,
  inputs,
  ...
}: {
  flake.homeModules.rio = {pkgs, ...}: {
    programs.rio = {
      enable = true;
      settings = {
        confirm-before-quit = false;

        cursor = {
          shape = "block";
          blinking = true;
        };

        navigation = {
          mode = "Tab";
          hide-if-single = true;
        };

        padding-x = 10;
        padding-y = [10 10];

        renderer = {
          performance = "High";
          backend = "Automatic";
        };

        scroll = {
          multiplier = 1;
          divider = 1;
        };

        title = {
          content = "{{ TITLE || PROGRAM }}";
          placeholder = "Rio";
        };

        window = {
          opacity = 0.8;
          blur = true;
          decorations = "Disabled";
        };
      };
    };
  };
}
