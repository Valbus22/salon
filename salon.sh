#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ The Salon ~~~~~\n"
echo "How may I help you?"
SERVICE_LIST=$($PSQL "SELECT service_id,name FROM services")


MAIN_MENU(){
if [[ $1 ]]
then
  echo "$1"
fi  
echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo  "$SERVICE_ID) $SERVICE_NAME"
done
echo -e "\nWhich service?\n"
read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
  MAIN_MENU "PLEASE SELECT VALID OPTION"
else
  SERVICES
fi
}


SERVICES(){
  SELECT_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  
  if [[ -z $SELECT_SERVICE ]]
  then
    MAIN_MENU "SELECT VALID OPTION"
  else
   
   echo "What's your phone number"
   read CUSTOMER_PHONE
   GET_CUSTOMER_INFO=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
   if [[ -z $GET_CUSTOMER_INFO ]]
   then
    echo "What's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    echo $INSERT_CUSTOMER_RESULT
   else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
   fi
   echo "What time would you like$SELECT_SERVICE,$CUSTOMER_NAME?"
   read SERVICE_TIME
   GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
   INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID_SELECTED,$GET_CUSTOMER_ID,'$SERVICE_TIME')")
   echo "I have put you down for a$SELECT_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

  fi
}

MAIN_MENU
