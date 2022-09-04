#!/bin/sh
touch bootstrap.sql
> bootstrap.sql

echo " -- GENERATED "$(date +%FT%T.%N) >> bootstrap.sql
printf "\n\n" >> bootstrap.sql

cat ../../medic-projects/middleware/postgresql/useful-queries/f_cast_isots.sql >> bootstrap.sql
printf "\n\n" >> bootstrap.sql

cat formviews/formview_case_investigation.sql >> bootstrap.sql
printf "\n\n" >> bootstrap.sql

cat formviews/formview_contact_follow_up.sql >> bootstrap.sql
printf "\n\n" >> bootstrap.sql

cat get_dashboard_data.sql >> bootstrap.sql
printf "\n\n" >> bootstrap.sql


cat indexes.sql >> bootstrap.sql
printf "\n\n" >> bootstrap.sql