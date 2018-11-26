# Prepend/Append plugin parcel classpaths

if [ "$HADOOP_USER_CLASSPATH_FIRST" = 'true' ]; then
  # HADOOP_CLASSPATH={{HADOOP_CLASSPATH_APPEND}}
  :
else
  # HADOOP_CLASSPATH={{HADOOP_CLASSPATH}}
  :
fi
# JAVA_LIBRARY_PATH={{JAVA_LIBRARY_PATH}}

export HADOOP_MAPRED_HOME=$( ([[ ! '{{CDH_MR2_HOME}}' =~ CDH_MR2_HOME ]] && echo {{CDH_MR2_HOME}} ) || echo ${CDH_MR2_HOME:-/usr/lib/hadoop-mapreduce/}  )
export HADOOP_CLIENT_OPTS="-Xmx268435456 -Djava.net.preferIPv4Stack=true $HADOOP_CLIENT_OPTS"
export HADOOP_CLIENT_OPTS="-Djava.net.preferIPv4Stack=true $HADOOP_CLIENT_OPTS"
export YARN_OPTS="-Xmx825955249 -Xms268435456 -Xmx268435456 -Djava.net.preferIPv4Stack=true $YARN_OPTS"
