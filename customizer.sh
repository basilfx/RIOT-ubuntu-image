#!/bin/bash

DIR=`dirname $0`

# Parse the action
ACTION="$1"
shift

if [[ -z $ACTION ]]; then
    echo "Usage: $0 <unpack|customize|repack|all>"
    exit 0
fi

# Parse the rest of the command line as arguments.
while [[ $# > 1 ]]; do
    OPTION="$1"

    case $OPTION in
        -o)
            OUTPUT="$2"
            shift
        ;;
        -i)
            IMAGE="$2"
            shift
        ;;
        -t)
            TARGET="$2"
            shift
        ;;
        *)
            echo "Unknown option: $OPTION"
            exit 1
        ;;
    esac

    # Shift value from stack.
    shift
done

# Run the given action with parsed arguments.
case $ACTION in
    "unpack")
        if [[ -z "$IMAGE" || -z "$TARGET" ]]; then
            echo "Usage: $0 unpack -i <image> -t <target>"
            exit 1
        fi

        source "$DIR/lib/unpack.sh"
    shift
    ;;
    "customize")
        if [[ -z "$TARGET" ]]; then
            echo "Usage: $0 customize -t <target>"
            exit 1
        fi

        source "$DIR/lib/customize.sh"
    shift
    ;;
    "repack")
        if [[ -z "$OUTPUT" || -z "$TARGET" ]]; then
            echo "Usage: $0 unpack -o <output> -t <target>"
            exit 1
        fi

        source "$DIR/lib/repack.sh"
    shift
    ;;
    "all")
        if [[ -z "$IMAGE" || -z "$OUTPUT" || -z "$TARGET" ]]; then
            echo "Usage: $0 all -i <image> -o <output> -t <target>"
            exit 1
        fi

        source "$DIR/lib/unpack.sh"
        source "$DIR/lib/customize.sh"
        source "$DIR/lib/repack.sh"
    shift
    ;;
    *)
        echo "Unknown action: $ACTION"
        exit 1
    ;;
esac



