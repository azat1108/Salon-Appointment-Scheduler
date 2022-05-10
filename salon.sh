#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  LIST_OF_SERVICES=$($PSQL "SELECT * FROM services")
  echo -e "$LIST_OF_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
  echo -e "4) exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT;;
    2) MAKE_APPOINTMENT;;
    3) MAKE_APPOINTMENT;;
    4) EXIT;;
    *) MAIN_MENU "I could not find that service. What would you like today?\n" ;;
  esac
}
MAKE_APPOINTMENT() {
  #get SERVICE_NAME
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ |/"/')
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi
  # get 
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ |/"/')
  #get SERVICE_TIME
  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME
  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # insert bike rental
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
}
EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"
LIST_OF_SERVICES=$($PSQL "SELECT * FROM services")
echo -e "$LIST_OF_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo -e "$SERVICE_ID) $SERVICE_NAME"
done
echo -e "4) exit"
read SERVICE_ID_SELECTED
case $SERVICE_ID_SELECTED in
  1) MAKE_APPOINTMENT;;
  2) MAKE_APPOINTMENT;;
  3) MAKE_APPOINTMENT;;
  4) EXIT;;
  *) MAIN_MENU "I could not find that service. What would you like today?\n" ;;
esac