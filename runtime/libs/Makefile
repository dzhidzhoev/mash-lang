all: bf/libbf.dylib crt/libcrcrt.dylib math/librt_math.dylib streams/libstreams.dylib svm_api.o
	
bf/libbf.dylib: bf/bf.pas
	fpc bf/bf.pas
	
crt/libcrcrt.dylib: crt/crcrt.lpr
	fpc crt/crcrt.lpr
	
math/librt_math.dylib: math/rt_math.pas
	fpc math/rt_math.pas
	
streams/libstreams.dylib: streams/streams.pas
	fpc streams/streams.pas
	
svm_api.o: svm_api.pas
	fpc svm_api.pas
	
clean:
	rm bf/*.o bf/*.dylib
	rm crt/*.o crt/*.dylib
	rm math/*.o math/*.dylib
	rm streams/*.o streams/*.dylib
	rm svm_api.o svm_api.ppu