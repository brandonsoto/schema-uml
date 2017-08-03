#!/bin/bash

PROTO_DIR=$PWD/proto
PROTO_OUT_DIR=$PWD/proto_out
FILE_DESCRIPTOR_SET=$PROTO_OUT_DIR/MyFileDescriptorSet.pb
PYTHONPATH=$PWD:$PROTO_OUT_DIR

mkdir -p $PROTO_OUT_DIR

# Generate descriptor_pb2.py with protoc:
protoc -I=$PWD --python_out=$PROTO_OUT_DIR $PWD/descriptor.proto

# convert .proto files into a serialized FileDescriptorSet for input into descriptor2uml.py
protoc -I=$PROTO_DIR --include_source_info -o $FILE_DESCRIPTOR_SET $PROTO_DIR/messages.proto $PROTO_DIR/messages2.proto

export PYTHONPATH=$PYTHONPATH

# Make the dot file which describes the UML diagram. The type_header_comments file can be empty (or you can remove the option altogether)
python descriptor2uml.py --descriptor $FILE_DESCRIPTOR_SET --dot uml.dot # --urls schema_urls #--type_comments type_header_comments

# Finally, draw the UMl diagram
dot uml.dot -T svg -o uml.svg
