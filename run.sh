#!/bin/bash
#HEALTH CHECK QRADAR - LEADCOMM SCRIPT COPYRIGHT - ALL RIGHTS RESERVED


VAR[0]=$( hostnamectl | grep -i hostname | xargs ) ; 
VAR[1]=$( hostname -I | awk -F ' ' '{print $1}' ) ; 

VAR2=/tmp/LEADCOMM-HC/
VAR3=/tmp/LEADCOMM-HC.tar.gz



function LEADCOMM_F00 () {
echo "=================================================================="
echo "       _                    _                                     "
echo "      | |                  | |                                    "
echo "      | |     ___  __ _  __| | ___ ___  _ __ __   _ __ ___        "
echo "      | |    / _ \/ _  |/ _| |/ __/ _ \|  _  _ \ | _  _   _\      "
echo "      | |___| /__/ (_| | (_| | (_| (_) | | | | | | | | | | |      "
echo "      |______\___|\__,_|\__,_|\___\___/|_| |_| |_|_| |_| |_|      "
echo "                                                                  "
echo "=================================================================="

if [ -e "$VAR2" ] ; then

    echo " The file /tmp/LEADCOMM-HC already exists, please remove it and try again. "
    sleep 2
    exit 0
         
		 elif [ -e "$VAR3" ]; then

               echo " The file /tmp/LEADCOMM-HC.tar.gz already exists in this directory, please remove it and try again. "
               sleep 2
               exit 0

         else

    sleep 1
fi

}

function LEADCOMM_F01() {
      
  `locate all_servers.sh` -C " echo -e '\nLEADCOMM_HC0001 \n' &&  df -h && echo -e '\nLEADCOMM_HC0002 \n' && free -m && echo -e '\nLEADCOMM_HC0003 \n' && lscpu && echo -e '\nLEADCOMM_HC0004 \n' && dmesg | grep smpboot && echo -e '\nLEADCOMM_HC0005 \n' && top -n 4 -b | grep '%Cpu(s): ' && eclho -e '\nLEADCOMM_HC0006 \n' && top -n 1 -b | grep 'zombie'"  
  
}

function LEADCOMM_F02() {

  `locate all_servers.sh` -C " echo -e '\nLEADCOMM_HC0007 \n' &&  hostnamectl && echo -e '\nLEADCOMM_HC0008 \n' &&  ifconfig && echo -e '\nLEADCOMM_HC0009 \n' && ip r && echo -e '\nLEADCOMM_HC00010 \n' && /opt/qradar/bin/myver -v  "
}

function LEADCOMM_F03() {

 echo -e '\nLEADCOMM_HC00011 \n' && psql -U qradar -c "select name, description, version from ale_client" 
 echo -e '\nLEADCOMM_HC00012 \n' && psql -U qradar -c "select hostname, devicename, TO_CHAR(TO_TIMESTAMP(timestamp_last_seen/1000), 'YYYY/MM/DD') as LastSeen from sensordevice where id IN (select id from sensordevice where devicename like 'WinCollect%') and deviceenabled='t' order by lastseen desc"
 echo -e '\nLEADCOMM_HC00013 \n' && psql -U qradar -c "select hostname, devicename, TO_CHAR(TO_TIMESTAMP(timestamp_last_seen/1000), 'YYYY/MM/DD') as LastSeen from sensordevice where id IN (select id from sensordevice where devicename like 'WinCollect%') and deviceenabled='f' order by lastseen desc"
 echo -e '\nLEADCOMM_HC00014 \n' && psql -U qradar -c "SELECT count(hostname) as total , sdt.devicetypename FROM sensordevice , sensordevicetype as sdt WHERE devicetypeid = sdt.id and deviceenabled='t'  GROUP BY sdt.devicetypename ORDER BY total desc;"
 echo -e '\nLEADCOMM_HC00015 \n' && psql -U qradar -c "SELECT count(hostname) as total , sdt.devicetypename FROM sensordevice , sensordevicetype as sdt WHERE devicetypeid = sdt.id and deviceenabled='f'  GROUP BY sdt.devicetypename ORDER BY total desc;"
 echo -e '\nLEADCOMM_HC00016 \n' && psql -U qradar -c "select id,name,description,image_repo,status,memory from installed_application;"
  
}

function LEADCOMM_F04() {
 
 
 echo -e '\nLEADCOMM_HC00016 \n' && cat  /var/log/qradar.error >> /tmp/LEADCOMM-HC/LEADCCOMM_F04.txt
 echo -e '\nLEADCOMM_HC00017 \n' && cat  /var/log/qradar.log >> /tmp/LEADCOMM-HC/LEADCCOMM_F05.txt
 
}

function LEADCOMM_F05(){

echo "-------------------------------------------------------------------------------------------"
echo " LEADCOMM  2020 | '${VAR[0]}' / '${VAR[1]}'                                                " 
echo "-------------------------------------------------------------------------------------------"
echo "  gravado em:  /tmp/LEADCOMM-HC/  "
echo 
echo 
echo 
echo " /LEADCOMM-HC.sh v1.0 - '${VAR[0]}' "
echo
echo "-------------------------------------------------------------------------------------------"

}

LEADCOMM_F00
echo 
PS3='PLEACE ENTER YOUR CHOICE: '
options=("Option 1 -> Collect data" "Option 2 -> Data analyze" "Option 3 -> Software Version" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1 -> Collect data")
         clear
         echo "COLETA 01/03" 
		 clear
		 mkdir -p /tmp/LEADCOMM-HC/
		 echo "...Creating the directory /tmp/LEADCOMM-HC"
		 sleep 2 		
			time LEADCOMM_F01 | tee -a /tmp/LEADCOMM-HC/LEADCCOMM_F01.txt 
		 sleep 2
		 clear
		 echo "COLETA 02/03" 
		 sleep 3 		
		 	time LEADCOMM_F02 | tee -a /tmp/LEADCOMM-HC/LEADCCOMM_F02.txt 
		 sleep 3
         clear
		 echo "COLETA 03/03"
         sleep 2
            time LEADCOMM_F03 | tee -a /tmp/LEADCOMM-HC/LEADCCOMM_F03.txt 			 
    			 LEADCOMM_F04
				 tar -czvf  LEADCOMM-HC.tar.gz  /tmp/LEADCOMM-HC
		 sleep 3
		 clear
		 echo "FIM"
         sleep 3
		 clear
            LEADCOMM_F05
		 sleep 5
		 break
            ;;
        "Option 2 -> Data analyze")
               bash /tmp/LEADCOMM-HC/Synthesizer.sh
               if [ $? -eq 0 ]; then
                  bash /tmp/LEADCOMM-HC/Synthesizer.sh
                    else
                  echo "WAIT..." "SORRY, FILE NOT LOCATED"
               fi
            ;;
        "Option 3 -> Software Version")
		    clear
			LEADCOMM_F00
            echo			
            echo -en "LEADCOMM HEALTH CHECK - VERSÃO 1.0\n"
			echo -en "Option 1 -> Collect data Option 2 -> Data analyze Option 3 -> Software Version Quit"
			echo
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
