# sql2slack test

fork from https://github.com/alash3al/sql2slack do some change for support webhook

> for test with dingding 


## how to running


* create dingding webhook 

* create job hcl file

>  hcls dir

```code
job tst {
    channel = "<replace with you dingding webhook address>"

    driver = "mysql"

    dsn = "root:demo@tcp(mysql:3306)/demo"

    query = <<SQL
        SELECT users.* FROM users where status =1
    SQL

    schedule = "* * * * *"

    message = <<JS
        if ( $rows.length < 1 ) {
            return
        }
        log("this is a demo")
        var msg =  "";
         _.chain($rows).pluck('name').each(function(name){
            msg += name+"--------";
        })
         var info = {
            msgtype: "text",
            text: {
                content: msg
            }
        }
        log(JSON.stringify(info))
        say(JSON.stringify(info))
    JS
}
```

* start mysql service

```code
docker-compose up -d mysql
```

* init tables

```code
CREATE TABLE `users` (
  `name` varchar(100) ,
  `status` varchar(100)
) ENGINE=InnoDB

INSERT INTO demo.users
(name, status)
VALUES('dalong', '0');
INSERT INTO demo.users
(name, status)
VALUES('demo', '1');
INSERT INTO demo.users
(name, status)
VALUES('rong', '1');

```


* start sql2slack service

```code
docker-compose up -d sql2slack
```