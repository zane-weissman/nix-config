#!/bin/fish

echo $OUT_PATHS
echo $DRV_PATHS

if string match -q -- "home-manager-generation" $DRV_PATHS
  echo "Successfully built home-manager"
end
