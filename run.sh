#!/bin/bash

mkdir -p mods
mkdir -p mlib
mkdir -p obfuscated-mlib

JH=$(which java)
JH=$(dirname $JH)
JH=$(dirname $JH)
SOURCES=$(find src -name "*.java")

javac -d mods --module-source-path src $SOURCES
jar --create --file=mlib/demo.jar --main-class=com.demo.Main -C mods/demo .
java -p mlib -m demo

java -jar proguard-6-1-1.jar \
    -injars mlib/demo.jar \
    -outjars obfuscated-mlib/demo.jar \
    -libraryjars "${JH}/jmods/java.base.jmod(!module-info.class)" \
    -printmapping obfuscated-mlib/demo.jar.map \
    -dontoptimize \
    -dontshrink \
    -useuniqueclassmembernames \
    -dontusemixedcaseclassnames \
    -adaptclassstrings \
    -renamesourcefileattribute stripped \
    -keepattributes Module*,Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,RuntimeVisible*Annotations,EnclosingMethod,AnnotationDefault \
    -keep class module-info

echo
echo
echo "--- Module attributes in module-info.class ---"
javap -private -verbose "jar:file://$PWD/obfuscated-mlib/demo.jar!/module-info.class" | tail -18
echo
echo

jmod create --class-path=obfuscated-mlib/demo.jar obfuscated-mlib/demo.jmod