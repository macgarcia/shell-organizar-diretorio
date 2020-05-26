#!/bin/bash

TIPOS_IMAGENS="JPEG JPG BMP PNG"
TIPOS_DOCUMENTOS="ODT PDF CSV TXT"
TIPOS_VIDEOS="MKV AVI MP4 MPEG"

declare -a img
declare -a doc
declare -a vid

_arquivo=""
_caminho=""

# function teste() {
#    _count=0
#    local _arquivo=$(cat .arqs)
#    for i in $_arquivo; do
#       echo ${i##*.}
#       echo ${i}
#    done
# }

function devolver_extensao() {
   echo $(echo $1 | cut -d\. -sf2- | tr '[:lower:]' '[:upper:]')
}

function corrigir_nome_arquivo() {
   echo $(echo $1 | tr "|" " ")
}

function arrumar() {
   cd $_caminho
   mkdir imagens documentos videos outros 2>&-
   
   for arq in ${img[@]}; do
      local _nome=$(corrigir_nome_arquivo $arq)
      mv "$_nome" "$_caminho/imagens"
   done
   
   for arq in ${doc[@]}; do
      local _nome=$(corrigir_nome_arquivo $arq)
      mv "$_nome" "$_caminho/documentos"
   done
   
   for arq in ${vid[@]}; do
      local _nome=$(corrigir_nome_arquivo $arq)
      mv "$_nome" "$_caminho/videos"
   done
   
   local _resto=$(ls | tr " " "|")
   for arq in $_resto; do
      if [[ ! -d $arq ]]; then
         local _nome=$(corrigir_nome_arquivo $arq)
         mv "$_nome" "$_caminho/outros"
      fi
   done
}

function separar_videos() {
   local index=0
   for i in $_arquivo; do
      local _extensao=$(devolver_extensao $i)
      for tipo in $TIPOS_VIDEOS; do
         if [[ $tipo == $_extensao ]]; then
            vid[index]=$i
            ((index++))
         fi
      done
   done
}

function separar_documentos() {
   local index=0

   for i in $_arquivo; do
      local _extensao=$(devolver_extensao $i)
      for tipo in $TIPOS_DOCUMENTOS; do
         if [[ $tipo == $_extensao ]]; then
            doc[index]=$i
            ((index++))
         fi
      done
   done
}

function separar_imagens() {
   local index=0
   for i in $_arquivo; do
      local _extensao=$(devolver_extensao $i)
      for tipo in $TIPOS_IMAGENS; do
         if [[ $tipo == $_extensao ]]; then
            img[index]=$i
            ((index++))
         fi
      done
   done
}


function iniciar() {
   if [[ ! -d $1 ]]; then
      echo "Diretório não existe"
      exit 1
   fi
   
   _caminho=$1
   _arquivo=$(ls $1 | tr " " "|")
   
   #teste
   
   #Função para separar as imagens
   separar_imagens
   
   #Função para separar os documentos
   separar_documentos
   
   #Função para separar os videos
   separar_videos
   
   #Função para arrumar os diretórios
   arrumar

   exit 0
}

iniciar $1

