#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if not argument
if [[ ! $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

ATOM_DETAIL(){
  echo $($PSQL "SELECT atomic_number, symbol, name, atomic_mass, type, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE $1 = '$2';")
}

PRINT_RESULT(){
  echo "The element with atomic number $1 is $2 ($3). It's a $4, with a mass of $5 amu. $2 has a melting point of $6 celsius and a boiling point of $7 celsius."
}

# find by number
if [[ $1 =~ ^[0-9]+$ ]]
then
  ATOM_INFO_RESULT=$(ATOM_DETAIL atomic_number $1)
# find by letter
elif [[ $1 =~ ^[A-Za-z]+$ ]]
then
  if [[ ${#1} -le 2 ]]
  then
    ATOM_INFO_RESULT=$(ATOM_DETAIL symbol $1)
  else
    ATOM_INFO_RESULT=$(ATOM_DETAIL name $1)
  fi
else
  echo "Incorrect request"
fi

if [[ -z $ATOM_INFO_RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo $ATOM_INFO_RESULT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR TYPE BAR MELTING BAR BOILING
  do
    PRINT_RESULT $ATOMIC_NUMBER $NAME $SYMBOL $TYPE $ATOMIC_MASS $MELTING $BOILING
  done
fi
