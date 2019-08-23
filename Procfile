webserver: rerun -- rackup -p 4567 config.ru
tests: rerun -x rake
worker: QUEUE=events rerun -- rake resque:work
