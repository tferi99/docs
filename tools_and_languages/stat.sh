FILES=`find . -type f -name "*.txt" | wc -l`
LINES=`find . -type f -name "*.txt" -exec wc -l {} \; | awk '{ SUM += $0} END { print SUM }'`

echo "Files: $FILES"
echo "Lines: $LINES"


