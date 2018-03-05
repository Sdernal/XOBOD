OUT_DIR="out"
NUM_REDUCERS=4

hadoop fs -rm -r -skipTrash ${OUT_DIR}.tmp

hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.name="NE count step1" \
    -D mapreduce.job.reduces=$NUM_REDUCERS \
    -files mapper1.py,reducer1.py \
    -mapper "python mapper1.py" \
    -reducer "python reducer.py" \
    -input /data/wiki/en_articles_part \
    -output ${OUT_DIR}.tmp


hadoop fs -rm -r -skipTrash ${OUT_DIR}

hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.name="NE count step2" \
    -D mapreduce.job.reduces=1 \
    -D mapreduce.partition.keycomparator.options=-k1,1nr \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -files swapper.py \
    -mapper "python swapper.py" \
    -reducer "python swapper.py" \
    -input ${OUT_DIR}.tmp \
    -output ${OUT_DIR}

hadoop fs -cat ${OUT_DIR}/part-00000 | head