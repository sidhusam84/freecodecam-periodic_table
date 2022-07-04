#! /bin/bash

PSQL="psql --username=postgres --dbname=periodic_table -t --no-align -c"

if [ $# -eq 0 ]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+ ]] && ! [[ $1 =~ [a-z,A-Z] ]]
  then
    #echo "Number is passed"
    ELEMENT_BY_ATOMIC_N=$($PSQL "select elements.atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements INNER JOIN properties USING(atomic_number) INNER JOIN types using(type_id) where elements.atomic_number=$1")
    
    if [[ -z $ELEMENT_BY_ATOMIC_N ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT_BY_ATOMIC_N" | while IFS="|" read atomic_number name symbol ty atomic_mass mel_point boil_point
      do
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $ty, with a mass of $atomic_mass amu. $name has a melting point of $mel_point celsius and a boiling point of $boil_point celsius."
      done  
    fi  

  elif [[ $1 =~ ^[A-Z]  ]] && [[ ${#1} -le 2 ]]
  

  then
    ELEMENT_BY_SYMBOL=$($PSQL "select elements.atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) where elements.symbol='$1'")
    #echo "it is symbol, $1"
    if [[ -z $ELEMENT_BY_SYMBOL ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT_BY_SYMBOL" | while IFS="|" read atomic_number name symbol ty atomic_mass mel_point boil_point
      do
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $ty, with a mass of $atomic_mass amu. $name has a melting point of $mel_point celsius and a boiling point of $boil_point celsius."
      done  
    fi  

  elif [[ $1 =~ ^[A-Z,a-z][a-z]+ ]] && ! [[ $1 =~ [0-9] ]]
  then
    ELEMENT_BY_NAME=$($PSQL "select elements.atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) where elements.name='$1'")
    #echo "it is name,$1"  
    if [[ -z $ELEMENT_BY_NAME ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$ELEMENT_BY_NAME" | while IFS="|" read atomic_number name symbol ty atomic_mass mel_point boil_point
      do
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $ty, with a mass of $atomic_mass amu. $name has a melting point of $mel_point celsius and a boiling point of $boil_point celsius."
      done  
    fi 

  else
    echo "Wrong argument"  
  fi  
fi
