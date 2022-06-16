#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE '$1' IN (symbol, name)")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE $1=atomic_number")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
    exit
  fi
  ATOMIC_NUMBER="${ATOMIC_NUMBER#"${ATOMIC_NUMBER%%[![:space:]]*}"}"
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  SYMBOL="${SYMBOL#"${SYMBOL%%[![:space:]]*}"}"
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  ATOMIC_MASS=$($PSQL "SELECT ''||atomic_mass||'' FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT ''||melting_point_celsius||'' FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT ''||boiling_point_celsius||'' FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is$NAME ($SYMBOL). It's a$TYPE, with a mass of$ATOMIC_MASS amu.$NAME has a melting point of$MELTING_POINT celsius and a boiling point of$BOILING_POINT celsius."
 
else
  echo "Please provide an element as an argument."
  exit
fi