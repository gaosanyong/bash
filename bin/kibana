#!/bin/bash --
#
# The Listing Service is set running in a private Vpc. As a result, in order to
# access its outcome via Amazon OpenSearch Service, a private connection needs to
# be established. The steps are detailed here:
#
# https://w.amazon.com/bin/view/SSPA/PASF/CAMP/airstream/Services/CAMPListingService/#HKibanasetup
#
# This script is a convenience wrapper to semi-automate a few steps in the doc.
# Upon running FoxyProxy, one can run for example ./kibana BetaNA to connect to
# BetaNA instance.
#
# One important feature is that the EC2 public IPv4 is required to connect to
# Kibana. However, this IPv4 address can change due to change of EC2 instance.
# Here, we provide a flag -u (--update) to update the IPv4 address of a given
# instance so that no more manual lookup is ever required.
#
# Usage:
#       kibana.sh [-uv] [--help] [--update] [--view] [dg]
#              --help     return help summary
#           -u --update   update IPv4 address
#           -v --view     view IPv4 address

set -e
trap 'rm $temp 2> /dev/null' EXIT HUP INT PIPE QUIT TERM

program=$(basename $0)
while getopts :r:vu-: opt; do
    [[ $opt = '-' ]] && opt=$OPTARG && OPTARG=-$OPTARG
    case $opt in
            help)      echo "Usage: $program [-uv] [--help] [--update] [--view] [dg]"
                       exit 0
                       ;;
        u | update)    update=true
                       ;;
        v | view)      view=true
                       ;;
        \? | *)        echo "$program: invalid option -$OPTARG" >&2
                       exit 1
    esac
done
shift $((OPTIND - 1))

if (( $# >= 2 )); then
    echo "$program: too many arguments" >&2
    exit 1
fi

ipv4="$HOME/.pem/ipv4"
if [[ ! -f $ipv4 ]]; then
    mkdir -p $(dirname $ipv4) && touch $ipv4
    echo "AlphaNA 070996443603 us-west-2" >> $ipv4
    echo "BetaFE  049056783271 us-east-1" >> $ipv4
    echo "BetaEU  242736183260 eu-west-1" >> $ipv4
    echo "BetaNA  202446405433 us-west-2" >> $ipv4
    echo "GammaFE 509910006847 us-west-2" >> $ipv4
    echo "GammaEU 937974478185 eu-west-1" >> $ipv4
    echo "GammaNA 193756809243 us-east-1" >> $ipv4
    echo "ProdFE  976910458176 us-west-2" >> $ipv4
    echo "ProdEU  355116250786 eu-west-1" >> $ipv4
    echo "ProdNA  389817083726 us-east-1" >> $ipv4
    echo "initialized IPv4 file"
fi

temp="$HOME/.pem/ipv4.$$"
touch $temp
while read dg account region ip; do
    if [[ -z $1 || $dg == $1 ]]; then
        if ${update:-false}; then
            echo "retrieving ipv4 address of $dg ($account)"
            ada credentials update --account=$account --provider=conduit --role=Ec2ReadOnlyAccessRoleKibana --once
            aws configure set region $region
            ip=$(aws ec2 describe-instances \
                      --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=CAMPListing-$1-Ec2ProxyProxy" \
                      --query 'Reservations[*].Instances[*].[PublicIpAddress]' \
                      --output text)
        elif ${view:-false}; then
            printf "%-7s %12s %9s %15s\n" $dg $account $region $ip
        fi
        [[ $dg == ${1:-AlphaNA} ]] && found=true && ipaddress=$ip
    fi
    printf "%-7s %12s %9s %15s\n" $dg $account $region $ip >> $temp
done < $ipv4
mv $temp $ipv4

if [[ -n $1 ]] && ! ${found:-false}; then
    echo "$program: invalid argument '$1'" >&2
    exit 1
elif ${update:-false} || ${view:-false}; then
      exit 0
elif [[ -z $ipaddress ]]; then
    echo "$program: run \`$program --update ${1:-AlphaNA}\` to populate empty ipv4" >&2
    exit 1
fi

if [[ ! -f $HOME/.pem/listing-service-proxy.pem ]]; then
    ada credentials update --account=202446405433 --provider=conduit --role=IibsAdminAccess-DO-NOT-DELETE --once
    aws s3 sync s3://airstream-kibana-access $HOME/.pem/
    chmod 400 $HOME/.pem/listing-service-proxy.pem
fi
pkill -f listing-service-proxy.pem || echo "Tunneling $1 ($ipaddress) to FoxyProxy"
ssh -i $HOME/.pem/listing-service-proxy.pem ec2-user@$ipaddress -ND 9202
