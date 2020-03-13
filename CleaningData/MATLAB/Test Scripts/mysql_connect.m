function mysql_connect(db, user, pw)
dbname = db;
username = user;
password = pw;
driver = 'com.mysql.jdbc.Driver';

% useSSL=false doesn't work for some reason
% Ignore the warning for now
dburl = ['jdbc:mysql://localhost:3306/' dbname %{'?useSSL=false'%}
        ];

javaaddpath('/home/eeglewave/Documents/MATLAB/mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar')

conn = database([dbname ''], username, password, driver, dburl);

query = 'SELECT * FROM table_id;';
curs = exec(conn, query);

curs = fetch(curs);
curs.Data

close(curs)
close(conn)