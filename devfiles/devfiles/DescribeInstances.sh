#!/bin/bash

## Shell script to SSH onto each application group

## Pass Variables

AWS_ACCOUNT_NAME=$(aws iam list-account-aliases --output text | awk '{print $2}')
TOKEN=$(curl -X PUT http://169.254.169.254/latest/api/token -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document|grep region |awk -F\" '{print $4}') ;

main() {
    cd /

    PS3="Select from the menu to find the IP addresses of the Auto Scaling Group: "
    COLUMNS=12
    select ch in "EKS Manager AFL Mens" "EKS Manager AFL Clubs" "EKS Manager AFL Womens" "EKS Manager AFL MIS" "Proxy CMS" "Proxy API" "Proxy Delivery" "Mens Cache" "Clubs Cache" "Womens Cache" "MIS Cache" "Player Tracker" "Identity" "MISDelivery" "MISPremium" "MISPush" "MISStatsPro" "MISMgmt" "MISTMIVI" "DynatraceAG" Quit

    do
        case $ch in
            "EKS Manager AFL Mens")
                DescribeInstanceFunction "EKSManager-AFLMens*"
                ;;
            "EKS Manager AFL Clubs")
                DescribeInstanceFunction "EKSManager-AFLClubs*"
                ;;
            "EKS Manager AFL Womens")
                DescribeInstanceFunction "EKSManager-AFLWomens*"
                ;;
            "EKS Manager AFL MIS")
                DescribeInstanceFunction "EKSManager-AFLMIS*"
                ;;
            "Proxy CMS")
                DescribeInstanceFunction "ProxyCMS*"
                ;;
            "Proxy API")
                DescribeInstanceFunction "ProxyAPI*"
                ;;
            "Proxy Delivery")
                DescribeInstanceFunction "ProxyDelivery*"
                ;;
            "Mens Cache")
                DescribeInstanceFunction "*AFLMCache*"
                ;;
            "Clubs Cache")
                DescribeInstanceFunction "*AFLClubCache*"
                ;;
            "Womens Cache")
                DescribeInstanceFunction "*AFLWCache*"
                ;;
            "MIS Cache")
                DescribeInstanceFunction "*MISCache*"
                ;;
            "Player Tracker")
                DescribeInstanceFunction "*Tracker*"
                ;;
            "Identity")
                DescribeInstanceFunction "Identity*"
                ;;
            "MISDelivery")
                DescribeInstanceFunction "MISDeliveryASG*"
                ;;
            "MISPremium")
                DescribeInstanceFunction "MISPremiumASG*"
                ;;
            "MISPush")
                DescribeInstanceFunction "MISPushASG*"
                ;;
            "MISStatsPro")
                DescribeInstanceFunction "MISStatsProASG*"
                ;;
            "MISMgmt")
                DescribeInstanceFunction "MISMgmtASG*"
                ;;
            "MISTMIVI")
                DescribeInstanceFunction "MISTMIVIASG*"
                ;;
            "DynatraceAG")
                DescribeInstanceFunction "DynatraceAG*"
                ;;
            Quit)
                exit
                ;;
        esac
    done
}

function DescribeInstanceFunction() {
    #Pass variable to describe command
    aws ec2 describe-instances --query "Reservations[*].Instances[*].{AvailabilityZone:Placement.AvailabilityZone,PublicIP:PublicIpAddress,PrivateIPAddress:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
                               --region $REGION \
                               --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='${1}'" \
                               --output table
}

main "$@"

