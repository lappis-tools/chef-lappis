cd /lappis
export SECRET_KEY_BASE=$(rake secret)
export SECRET_TOKEN=$(rake secret)
cd /
