#!/usr/bin/env bash
#hpdb script

#statics
mgxcmd="../asterix-installer-0.9.1-binary-assembly/bin/managix"
AQLcmd="python3 AdapterAsterix/QueryInstance.py"
sparkcmd="../spark-2.3.0-bin-hadoop2.7/bin/spark-shell"
#function run
run(){
	read -e -p "HelpalDB>>> " cmd
	history -s "$cmd"
	while [ "$cmd" != "quit" ]
	do
		history -s "$cmd"
		#pre-process cmd
		cmdarr=($cmd)
		#run biggy
		case "${cmdarr[0]}" in
			#input
			"input")
			echo "input..."
			if [ ""${#cmdarr[@]}"" -le 3 ]
			then
				echo "path_from path_to missing!"
				read -e -p "HelpalDB>>> " cmd
				continue
			fi
			case "${cmdarr[1]}" in
				"-feed")
				cmd="create feed ""${cmdarr[2]}"" using socket_adapter() to dataset ""${cmdarr[3]}"";"
				echo "$cmd"
				;;
				"-file")
				cmd="dump file ""${cmdarr[2]}"" to dataset ""${cmdarr[3]}"";"
				echo "$cmd"
				;;
				*)
				echo "Paras Missing!"
				;;
			esac	
			echo "inputed."
			;;
			#store
			"store")
			echo "store..."
			case "${cmdarr[1]}" in
				"-new")
				cmd="create dataverse ""${cmdarr[2]}"" if not exists;"
                $AQLcmd "$cmd"
				;;
				"-delete")
				cmd="drop dataverse ""${cmdarr[2]}"";"
				$AQLcmd "$cmd"
				;;
				*)
				echo "Paras Missing!"
				;;
			esac			
			echo "stored."
			;;
			#compute
			"compute")
			echo "compute..."
			case "${cmdarr[1]}" in
				"-query")
				#cmd="use dataverse bigdb; for \$ds in dataset Metadata.Dataset return \$ds"
				cmd="${cmdarr[@]:2}"
				$AQLcmd "$cmd"
				;;
				"-analysis")
				cmd="${cmdarr[@]:2}"
                echo "$cmd" > data/testScala.scala
				$sparkcmd < data/testScala.scala
                #sc.parallelize(1 to 1000).count()
				;;
				*)
				echo "Paras Missing!"
				;;
			esac			
			echo "computed."
			;;
			#control
			"control")
			echo "control..."
			echo "Built-in Module. NO Configuration!"
			echo "controlled."
			;;
			#output
			"output")
			echo "output..."
			case "${cmdarr[1]}" in
				"-visual")
				cmd="${cmdarr[@]:2}"
				#write files to	../../d3/example/
				#start server
		        open -a Firefox ~/Desktop/HelpalDB/d3/example/index.html	
				;;
				"-share")
				cmd="${cmdarr[@]:2}"
				#$AQLcmd "$cmd"
				;;
				*)
				echo "Paras Missing!"
				;;
			esac			
			echo "outputed."
			;;
			#commond error
			*)
			echo "Command Error!"
			;;	
		esac	
		read -e -p "HelpalDB>>> " cmd
	done
}

if [ "$1" == "install" ]
then 
	#install projects
	echo "installing HelpalDB..."
	echo "installed HelpalDB."
elif [ "$2" != "HelpalDB" ]
then
	echo "Command Error!"
elif [ "$3" == "" ]
then 
	echo "Command Error!"
else
	#manage biggy
	case "$1" in
		#new
		"new")
		echo "newing HelpalDB ""$3""..."
		newcmd="create -n ""$3"" -c ../asterix-installer-0.9.1-binary-assembly/clusters/local/local.xml"
        #echo $mgxcmd
        #echo $newcmd
		$mgxcmd "$newcmd"
		echo "new HelpalDB ""$3"" end."
		;;
		#start
		"start")
		echo "starting HelpalDB ""$3""..."
		newcmd="start -n ""$3"
		$mgxcmd "$newcmd"
		echo "start HelpalDB ""$3"" end."
		#run
		;;
		#use
		"use")
		echo "using HelpalDB ""$3""..."
		run
		echo "use HelpalDB ""$3"" end."
		;;
		#stop
		"stop")
		echo "stopping HelpalDB ""$3""..."
		newcmd="stop -n ""$3"
		$mgxcmd "$newcmd"
		echo "stop HelpalDB ""$3"" end."
		;;
		#delete
		"delete")
		echo "deleting HelpalDB ""$3""..."
		newcmd="delete -n ""$3"
		$mgxcmd "$newcmd"
		echo "delete HelpalDB ""$3"" end."
		;;
		#info
		"info")
		echo "infoing HelpalDB ""$3""..."
		newcmd="describe -n ""$3"
		$mgxcmd "$newcmd"
		echo "info HelpalDB ""$3"" end."
		;;
		#commond error
		*)
		echo "Command Error!"
		;;	
	esac
fi
