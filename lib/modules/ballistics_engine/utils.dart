import 'dart:ffi';
import 'dart:io';

DynamicLibrary loadLibrary() => Platform.isAndroid
    ? DynamicLibrary.open('libballistics_engine_rs.so')
    : DynamicLibrary.process();
