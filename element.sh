#!/bin/bash

#To connect our PSQL to our scrip

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#Ask to provide an element as an argument in order to provide data

if [[ -z $1 ]]
 then
  echo  "Please provide an element as an argument."
  exit  # will tell the script to stop immediately
fi

#Condition that checks the argument

if [[ $1 =~ ^[0-9]+$ ]]
 then
  CONDITION="e.atomic_number= $1"
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
 then
 CONDITION="e.symbol= '$1'"
else
CONDITION="e.name= '$1'"
fi

#Variable that will combine all the tables so that we can call different columns in one

ELEMENT_TABLE=$($PSQL"SELECT
e.atomic_number,
e.symbol,
e.name,
p.atomic_mass,
p.melting_point_celsius,
p.boiling_point_celsius,
t.type
FROM elements e
JOIN properties p USING (atomic_number)
JOIN types t USING (type_id) WHERE $CONDITION
;")

#If argument does not exist(does not match any elements)

if [[ -z $ELEMENT_TABLE ]]
 then
  echo  "I could not find that element in the database."
  exit # will tell the script to stop immediately
fi

#Print the output

echo "$ELEMENT_TABLE" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
 do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
 done 
