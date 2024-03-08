#!/bin/bash
read RESTART

NEMOdir=`grep "NEMOdir=" run_nemo.sh | grep -v "#NEMOdir=" | cut -d '=' -f2 | cut -d '#' -f1 |sed -e "s/'//g ; s/ //g"`
NEMOdir=~/work_dir/model/MergedCode_G06-9321_isf-remap-9853_shlat2d-9854_isf-flx-986

echo "NEMOdir is $NEMOdir"

rm -rf TMPXUXU
mkdir TMPXUXU
cd TMPXUXU

rm -f rebuild_nemo.exe
ln -s ${NEMOdir}/TOOLS/REBUILD_NEMO/BLD/bin/rebuild_nemo.exe

mv ../${RESTART}_[0-9]???.nc .
NDOMAIN=`ls -1 ${RESTART}_[0-9]???.nc |wc -l`

cat > nam_rebuild << EOF
  &nam_rebuild
  filebase='$RESTART'
  ndomain=${NDOMAIN}
  /
EOF

cat nam_rebuild
echo " "
echo "./rebuild_nemo.exe"
./rebuild_nemo.exe

mv $RESTART.nc ..
cd ..

if [ -f $RESTART.nc ]; then
  rm -rf TMPXUXU
  echo " "
  echo "$RESTART.nc [oK]"
else
  echo "~!@#$%^&* $RESTART.nc has not been created"
fi
