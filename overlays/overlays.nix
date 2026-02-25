# Copyright 2022-2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
# This overlay patches packages in nixpkgs, and adds in some of the ghaf's
# packages.
#
#
final: prev: {
  my-google-chrome = import ./google-chrome { inherit prev; };
  my-slack = import ./slack { inherit prev; };
}
