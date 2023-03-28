#!/bin/bash
    
    echo "This is a Script of Functions for Customer_Delivery"
    
    echo "
    # This script is written to extract INTEL_L1_22_03_ALL_TYPE code from the raw code in 5G_NR_gNB and do the following 
    # It performs the following pre-requisites required to be done before compiling the Intel Integration Code
    # And performs the following functions:
    # Adding third party , cypheringlibrary, intel specific files and the changes that need to be done in it
    # Modifying the make.inc and the .gnb settings which are required to be done for the code.
    #And at the last compile the code."

    echo -e "\t***************** Build Type have below Customer ****************************"
    echo -e "\t         CA         DPDK        Source_Code              Simulator"
    echo -e "\tTYPE1:   No         Yes         Yes                      ${green}Binaries${reset}\n"
    echo -e "\tTYPE2:   Yes        Yes         Yes                      ${green}Binaries${reset} \n"
    echo -e "\tTYPE3:   No         Yes         Yes                      ${green}Binaries${reset}  \n"
    echo -e "\tTYPE4:   Yes        Yes         Yes                      ${green}Source(SA/NSA)${reset}\n"
    echo -e "\tTYPE5:   No         No          ${green}Yes${yellow}(target)${reset}              No  \n"
    echo -e "\tTYPE6:   Yes        Yes         Yes                      No \n"
    echo -e "\tTYPE7:   No         No          ${green}Yes${yellow}(Polte/VM_Ware)${reset}       No \n"
    echo -e "\tTYPE8:   Yes        Yes         Yes                      ${green}Source(SA)${reset}\n"
    echo -e "\tTYPE9:   Yes        Yes         Yes                      ${green}Binaries(FR1/FR2)${reset}\n"
    echo -e "\tTYPE10:  No         No          ${green}Yes${reset}${yellow}(Node Lock)${reset}           No  \n"
    
    echo "5g_nr_gnbs file must be in your directory and this script must be parallel to it before executing this script
    Eg      5g_nr_gnb
            All_Compile.sh

    You can git also clone from main branch"

    echo "Eg: git clone -b nr_dev_br http://upendra.gupta:glpat-Q_UwvCoLA6A3xCzApnah@git.intra.aricent.com/5g-development/5g_nr_gnb.git"

    echo "
    ############# THIS SCRIPT IS WRITTEN BY ###################
    #                                                         #
    #       UPENDRA       ANUBHAV      RAJNEESH.              #
    #                                                         #
    #                    MARCH-2023                           #
    ###########################################################
    "

    sleep 5

    # Read path name
    current_path=$(pwd)

    # Check if "5g_nr_gnb" directory exists and change to it
    if [ -d "5g_nr_gnb" ]; then
        echo ""
    else
        echo "5g_nr_gnb directory not found"
            exit 1
    fi

################## Function Description ###################
#                                                         #
# This function is taking user input for file type .      #
#                                                         #
###########################################################

function File_Type()
{
    read -p "
    Enter Type: (1-10)
    " file_type

    if ((file_type >= 1 && file_type <= 10)); then
        if ((file_type == 7)); then
             echo "
        This file type is outdated. You can use TYPE 5 instead of this"
        File_Type
        else    
            file_type="TYPE$file_type"
        fi
    else
        echo "
        Invalid file type. 
        Please Choose Between 1 to 10"
        File_Type
    fi
}

################## Function Description ###################
#                                                         #
# This function is taking user input for Mode      .      #
#                                                         #
###########################################################

function Mode()
{
    if [ $file_type == "TYPE4" ]; then
        read -p "
    For this type only COMMON MODE is available
    Enter Mode (3)
    1-->SA
    2-->NSA
    3-->COMMON
    " mode

        if ((mode == 1)); then
            echo "
        This mode is not available for this type. Please select 3"
            Mode
        elif ((mode == 2)); then
            echo "
        This mode will be available in future. Please select 3"
            Mode
        elif ((mode == 3)); then
            mode="COMMON"
        else
            echo "
        Invalid mode. Please select 3"
            Mode
        fi
    else     
        read -p "
    For this type only SA MODE is available
    1-->SA
    2-->NSA
    3-->COMMON
    " mode

        if ((mode == 1)); then
            mode="SA"
        elif ((mode == 2)); then
             echo "
        This mode will be available in future. Please select 1"
            Mode
        elif ((mode == 3)); then
             echo "
        This mode is not available for this type. Please select 1"
            Mode
        else
            echo "
        Invalid mode. Please select 1"
            Mode
        fi
    fi
}

################## Function Description ###################
#                                                         #
# This function is taking user input for Duplex    .      #
#                                                         #
###########################################################
function Duplex()
{
    read -p "
    Enter Duplexing(1/2)
    1-->TDD
    2-->FDD
    " duplex

    if ((duplex == 1)); then
        duplex="tdd"
    elif ((duplex == 2)); then
        duplex="fdd"
    else
        echo "
        Invalid duplexing. Please select 1/2"
        Duplex    
    fi
}

################## Function Description ###################
#                                                         #
# This function is taking user input for Frequency .      #
#                                                         #
###########################################################

function Freq()
{
    if [ $file_type == "TYPE9" ]; then
        read -p "
    FR1 + FR2 is available for this type
    1-->FR1
    2-->FR1+FR2
    " freq

        if ((freq == 1)); then
            echo "
            This Frequency is not available for this type. Please select 2"
            Freq
        elif ((freq == 2)); then
            freq="FR1"
        else
            echo "
            Invalid Frequency Range. Please select 2"
            Freq    
        fi
    else
       read -p "
    FR1 is available for this type
    1-->FR1
    2-->FR1+FR2
    " freq

        if ((freq == 1)); then
            freq="FR1"
        elif ((freq == 2)); then
            echo "
            This Frequency is not available for this type. Please select 1"
            Freq    
        else
            echo "
            Invalid Frequency Range. Please select 1"
            Freq    
        fi
    fi
}

################## Function Description ###################
#                                                         #
# This function is taking user input for DPDK.            #
#                                                         #
###########################################################
function Dpdk()

{
    if [ $file_type == "TYPE4" ]; then
        read -p "
    DPDK (1/2)
    1-->no_dpdk_exe
    2-->dpdk_host_exe
    " dpdk

    if ((dpdk == 1)); then
        dpdk="no_dpdk_exe"
    elif ((dpdk == 2)); then
        dpdk="dpdk_host_exe"
    else
        echo "
        Invalid DPDK. Please select 1/2"
        Dpdk    
    fi
    else 
        read -p "
    DPDK (no_dpdk_exe is available)
    1-->no_dpdk_exe
    2-->dpdk_host_exe
    " dpdk

        if ((dpdk == 1)); then
            dpdk="no_dpdk_exe"
        elif ((dpdk == 2)); then
            echo "
        dpdk_host_exe is not available for this type. Please select 1"
            Dpdk
        else
            echo "
        Invalid DPDK. Please select 1"
            Dpdk    
        fi
    fi
}

################## Function Description ###################
#                                                         #
# This function is taking user input for features.        #
#                                                         #
###########################################################
Feature () {
    read -p "Enter Features
    1-->No Feature Required
    2-->NETCONF
    3-->E2DU
    4-->CBSD

    Eg. If NETCONF and E2DU required then enter 2,3. If only NETCONF required then enter 2. If no feature required then enter 1
    " -r input

    IFS=',' read -ra input_array <<< "$input"

    features=()
    local no_feature_selected=false

    for i in "${input_array[@]}"; do
        if [[ $no_feature_selected == true ]]; then
            echo "No feature can be selected with other features. Please try again."
            Feature
            return
        fi

        case $i in
            1)
                no_feature_selected=true
                features=("")
                ;;
            2)
                if [[ " ${features[*]} " != *"NETCONF"* ]]; then
                    if [[ " ${features[*]} " == *"NETCONF"* ]]; then
                        echo "NETCONF feature is already selected. Please try again."
                        Feature
                        return
                    fi
                    features+=("NETCONF")
                fi
                ;;
            3)
                if [[ " ${features[*]} " != *"E2DU"* ]]; then
                    if [[ " ${features[*]} " == *"E2DU"* ]]; then
                        echo "E2DU feature is already selected. Please try again."
                        Feature
                        return
                    fi
                    features+=("E2DU")
                fi
                ;;
            4)
                if [[ " ${features[*]} " != *"CBSD"* ]]; then
                    if [[ " ${features[*]} " == *"CBSD"* ]]; then
                        echo "CBSD feature is already selected. Please try again."
                        Feature
                        return
                    fi
                    features+=("CBSD")
                fi
                ;;
            *)
                echo "Invalid input. Please try again."
                Feature
                return
                ;;
        esac
    done

    if [[ $no_feature_selected == true && ${#features[@]} > 1 ]]; then
        echo "Error: If No Feature Required is selected, no other features can be selected. Please try again."
        Feature
        return
    fi

    if [[ ${#features[@]} -eq 0 ]]; then
        echo "No features selected. Please try again."
        Feature
        return
    fi

    # echo "Selected features: ${features[*]}"
}

################## Function Description ####################
#                                                          #
# This function is taking user input for Confirmining.     #
#                                                          #
############################################################
function Confirm_Selection()
{
    echo "
    File_Type : $file_type
    Mode : $mode
    Duplex : $duplex
    Freq : $freq
    Feature : ${features[*]}
    "
    read -p"

    ./builHostBin_FLexran_release.sh INTEL $file_type $mode $duplex $freq $dpdk ${features[*]}
    
    Do you want to proceed? (y/n)
    " proceed
    
    if [ "$proceed" = "y" ]; then
        echo "Proceeding with the selected options..."
        Script
    else
        echo "Exiting..."
        exit 0
    fi
}

################## Function Description ##############################
#                                                                    #
# This function is extracting, making changes, copying and compiling.#                                          #
#                                                                    #
######################################################################

function Script()
{
    #Capturing time
    start=$(date +%s)

    # Read path name
    current_path=$(pwd)

    # Go to 5g_nr_gnb 
    cd 5g_nr_gnb/
            #  Check if "builHostBin_FLexran_release.sh" exists and copy it to the current directory
            if [ -f "Testing/pkg_gen_scripts/builHostBin_FLexran_release.sh" ]; then
                cp Testing/pkg_gen_scripts/builHostBin_FLexran_release.sh .
            else
                    echo "builHostBin_FLexran_release.sh not found"
                    exit 1
                fi

                # Run script to make zip file
               yes | ./builHostBin_FLexran_release.sh INTEL $file_type $mode $duplex $freq $dpdk ${features[*]}

                # Check exit status of previous command
                if [ $? -eq 0 ]; then
                        echo "Successful"
                    else
                        echo "Command failed"
                            exit 1
                        fi

    #Go to INTEL_(FILE_TYPE)
    cd INTEL_${file_type}_$mode

    #Unzip the file
    unzip NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_tdd.tgz.zip
    # Check exit status of previous command
    if [ $? -eq 0 ]; then
        echo "
        NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_tdd.tgz.zip Unzipped Sucessful"
    else
        unzip NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_FR2_tdd.tgz.zip
        if [ $? -eq 0 ]; then
            echo "
            NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_tdd.tgz.zip Unzipped Successful"
        else
        unzip NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_NSA_FR1_tdd.tgz.zip
        echo "
            NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_NSA_FR1_tdd.tgz.zip Unzipped Successful"
        fi
    fi
    #Untar the file
    tar -xzvf NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_tdd.tgz
    # Check exit status of previous command
    if [ $? -eq 0 ]; then
        echo "NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_tdd.tgz Untared Successful"
    else
        tar -xzvf NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_FR2_tdd.tgz
        if [ $? -eq 0 ]; then
            echo "
            NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_FR2_tdd.tgz Untared Successful"
        else 
            tar -xzvf NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_NSA_FR1_tdd.tgz
            echo "
            NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_NSA_FR1_tdd.tgz Untared Successful"
        fi
    fi

    #Untar NR_gNB_FRWK_1.0.0_Source_Code.tgz
    tar -xzvf 5G_GNB/SourceCode/NR_gNB_FRWK_1.0.0_Source_Code.tgz
    # Check exit status of previous command
    if [ $? -eq 0 ]; then
        echo "NR_gNB_FRWK_1.0.0_Source_Code.tgz Untared Successful"
    else
        #Untar NR_gNB_FRWK_1.0.0_Source_Code.tgz
        tar -xzvf NR_gNB_FRWK_1.0.0_Source_Code.tgz
        # Check exit status of previous command
        if [ $? -eq 0 ]; then
            echo "NR_gNB_FRWK_1.0.0_Source_Code.tgz Untared Successful"
        else
            echo "Untared Command failed"
        fi
    fi
    
    
        
    echo "
    All file Unzipped
    "
    sleep 3
    #Copy third party
    yes | cp -rf ../5G_IPR/gNB_SW/tools/third_party/ 5G_IPR/
    if [ $? -eq 0 ]; then
        echo "Third files copied"
    else
        echo "Third files not copied"  
        sleep 3                                  
    fi

    #Copy cyphering package
    yes | cp -f ../../5g_nr_gnb/cipheringPackage/src/5G_gNB_cipheringLibrary_r_1_0_0_0_3_src.tgz 5G_IPR/gNB_SW/
    if [ $? -eq 0 ]; then
        echo "Ciphering package copied"
    else
        echo "Ciphering package not copied"
        sleep 3
    fi
    echo "
    All packages copied
    "
    sleep 3
    echo "Copy below files in this directory
    1.  common_phy_chan_num.h
    2.  common_typedef.h
    3.  gnb_l1_l2_api.h (File not used after L1_21_03)
    4.  phy_printf.h
    5.  wls_lib.h>>
    "

    yes | cp -f ../../5g_nr_gnb/Testing/third_party/intel/inc/{common_phy_chan_num.h,common_typedef.h,gnb_l1_l2_api.h,phy_printf.h,wls_lib.h} 5G_IPR/gNB_SW/gNB_DU/mac/interfaces/phy/inc/intel/

    #Copy: lteMacWls_22_03.h to lteMacWls.h
    yes | cp 5G_IPR/gNB_SW/gNB_DU/mac/interfaces/phy/inc/intel/lteMacWls_22_03.h 5G_IPR/gNB_SW/gNB_DU/mac/interfaces/phy/inc/intel/lteMacWls.h

    #Copy: nr5g_mac_phy_api.h_22_03”  to nr5g_mac_phy_api.h
    yes | cp 5G_IPR/gNB_SW/gNB_DU/mac/interfaces/phy/inc/intel/nr5g_mac_phy_api.h_22_03 5G_IPR/gNB_SW/gNB_DU/mac/interfaces/phy/inc/intel/nr5g_mac_phy_api.h

    echo "Copy below files in this directory
    1.  common_phy_chan_num.h
    2.  common_typedef.h
    3.  gnb_l1_l2_api.h (File not used after L1_21_03)
    4.  phy_printf.h
    5.  wls_lib.h
    "

    yes |  cp -f ../../5g_nr_gnb/Testing/third_party/intel/inc/{common_phy_chan_num.h,common_typedef.h,gnb_l1_l2_api.h,phy_printf.h,wls_lib.h} 5G_IPR/gNB_SW/gNB_DU/mac/interfaces/phy/src/

    #Copy: lteMacWls_22_03.c to lteMacWls.c
    yes | cp 5G_IPR/gNB_SW/gNB_DU/mac/interfaces/phy/src/lteMacWls_22_03.c 5G_IPR/gNB_SW/gNB_DU/mac/interfaces/phy/src/lteMacWls.c

    echo "Modify make.inc to define below strings
    INTEL_FLEXRAN_5GNR
    NEW_EL_FLOW
    COMMON_INT_FLAG 
    INTEL_L1V_22_03
    "

    sed -i "s/-UINTEL_FLEXRAN_5GNR/-DINTEL_FLEXRAN_5GNR/g" 5G_IPR/gNB_SW/make.inc
    sed -i "s/-UNEW_EL_FLOW/-DNEW_EL_FLOW/g" 5G_IPR/gNB_SW/make.inc
    sed -i "s/-UCOMMON_INT_FLAG/-DCOMMON_INT_FLAG/g" 5G_IPR/gNB_SW/make.inc
    sed -i "s/-UINTEL_L1V_22_03/-DINTEL_L1V_22_03/g" 5G_IPR/gNB_SW/make.inc


    echo "Modify make.inc to define below strings
    INTEL_L1V_21_11 
    NEW_THREAD_MODEL
    NEW_THREAD_MODEL_1
    "

    sed -i "s/-DNEW_THREAD_MODEL_1/-UNEW_THREAD_MODEL_1/g" 5G_IPR/gNB_SW/make.inc
    sed -i "s/-DNEW_THREAD_MODEL/-UNEW_THREAD_MODEL/g" 5G_IPR/gNB_SW/make.inc
    sed -i "s/-DINTEL_L1V_21_11/-UINTEL_L1V_21_11/g" 5G_IPR/gNB_SW/make.inc

    echo "Modify gnb_settings
    INTEL_L1_22_03=1
    INTEL_L1_21_11=0
    RTE_SDK=/opt/dpdk-22.03/
    NR_PLATFORM=intel_nr
    "

    sed -i "s/NR_PLATFORM=host_nr/NR_PLATFORM=intel_nr/g" 5G_IPR/gNB_SW/.gnb_settings
    sed -i "s/INTEL_L1_21_11=1/INTEL_L1_21_11=0/g" 5G_IPR/gNB_SW/.gnb_settings
    sed -i "s/INTEL_L1_22_03=0/INTEL_L1_22_03=1/g" 5G_IPR/gNB_SW/.gnb_settings
    sed -i "s/export RTE_SDK=\/opt\/dpdk-20\.11\.3/export RTE_SDK=\/opt\/dpdk-21\.11/g" 5G_IPR/gNB_SW/.gnb_settings
    sed -i "s/export RTE_SDK=\/opt\/dpdk-20\.11\//export RTE_SDK=\/opt\/dpdk-21\.11\//g" 5G_IPR/gNB_SW/.gnb_settings 
    echo "
    Modification Done
    "
    #Go to 5G_IPR/gNB_SW/
    cd 5G_IPR/gNB_SW/
    . .gnb_settings

    #Compile gNB_Settings
    ./build.sh clean all;./build.sh all ${duplex} 2>&1 | tee log
    if [ $? -eq 0 ]; then
        echo "
                "
    else
            echo "
                                ╔═╗┌─┐┬┬  ┌─┐┌┬┐
                                ╠╣ ├─┤││  ├┤  ││
                                ╚  ┴ ┴┴┴─┘└─┘─┴┘        
    "
            exit 1
        fi
       

    #Delete the zip files
    rm -rf ../../../INTEL_${file_type}_$mode/NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_tdd.tgz
    rm -rf ../../../INTEL_${file_type}_$mode/NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_NSA_FR1_tdd.tgz

    rm -rf ../../../INTEL_${file_type}_$mode/NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_FR1_tdd.tgz.zip
    rm -rf ../../../INTEL_${file_type}_$mode/NR_gNB_FRWK_1.0.0_x86_CU_DU_SA_NSA_FR1_tdd.tgz.zip
    rm -rf ../../../INTEL_${file_type}_$mode/5G_GNB

    #Copy the main folder outside
    cp -rf ../../../INTEL_${file_type}_$mode/ ../../../../

    #Delete the dublicate folder
    rm -rf ../../../INTEL_${file_type}_$mode/
    rm -rf ../../../builHostBin_FLexran_release.sh

    end=$(date +%s)
    runtime=$((end-start))
    minutes=$((runtime / 60))
    seconds=$((runtime % 60))
    echo "Total time taken: $minutes minutes $seconds seconds"

}

File_Type
Mode
Duplex
Freq
Dpdk
Feature
Confirm_Selection
 
