echo off
..\..\..\Validation\cleanCFAST.bat
echo NRC_Users_Guide_Test_Cases
cd "1_Cabinet_Fire_in_MCR"
echo 1_Cabinet_Fire_in_MCR
"..\..\..\Bin\CFAST.exe" "Cabinet_fire_in_MCR" /V
echo 1_Cabinet_Fire_in_MCR_No_Ventilation
"..\..\..\Bin\CFAST.exe" "Cabinet_fire_in_MCR_No_Ventilation" /V
cd ..\
cd "2_Cabinet_Fire_in_Switchgear"
echo 2_Cabinet_Fire_in_Switchgear
"..\..\..\Bin\CFAST.exe" "Initial_Fire_Only" /V
"..\..\..\Bin\CFAST.exe" "Cabinet_fire_in_Switchgear" /V
cd ..\
cd "4_MCC_Fire_in_Switchgear"
echo 4_MCC_Fire_in_Switchgear
"..\..\..\Bin\CFAST.exe" "MCC_in_Switchgear" /V
cd ..\
cd "5_Trash_Fire_in_Cable_Spreading_Room"
echo 5_Trash_Fire_in_Cable_Spreading_Room
"..\..\..\Bin\CFAST.exe" "Trash_Fire_in_Cable_Spreading_Room" /V
cd ..\