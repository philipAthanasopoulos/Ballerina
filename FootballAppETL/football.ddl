create table countries
(
    id                                      bigint primary key not null,
    "ISO"                                   character varying,
    "ISO3"                                  character varying,
    "ISO_Code"                              integer,
    "FIPS"                                  character varying,
    "Display_Name"                          character varying,
    "Official_Name"                         character varying,
    "Capital"                               character varying,
    "Continent"                             character varying,
    "CurrencyCode"                          character varying,
    "CurrencyName"                          character varying,
    "Phone"                                 character varying,
    "Region_Code"                           double precision,
    "Region_Name"                           character varying,
    "Sub_region_Code"                       double precision,
    "Sub_region_Name"                       character varying,
    "Intermediate_Region_Code"              double precision,
    "Intermediate_Region_Name"              character varying,
    "Status"                                character varying,
    "Area_SqKm"                             double precision,
    "Population"                            bigint,
    "Small_Island_Developing_States_SIDS"   boolean,
    "Land_Locked_Developing_Countries_LLDC" boolean,
    "Least_Developed_Countries_LDC"         boolean,
    "Developed_or_Developing"               character varying
);

create table games
(
    id           bigint primary key not null,
    date         date,
    home_team_id bigint,
    away_team_id bigint,
    home_score   integer,
    away_score   integer,
    tournament   character varying,
    city         character varying,
    country_id   bigint,
    neutral      boolean,
    foreign key (away_team_id) references countries (id)
        match simple on update no action on delete no action,
    foreign key (home_team_id) references countries (id)
        match simple on update no action on delete no action
);

create table players
(
    id         bigint primary key not null,
    name       character varying,
    country_id bigint,
    foreign key (country_id) references countries (id)
        match simple on update no action on delete no action
);

create table goals
(
    id        bigint primary key not null,
    game_id   bigint,
    player_id bigint,
    own_goal  boolean,
    minute    integer,
    foreign key (game_id) references games (id)
        match simple on update no action on delete no action,
    foreign key (player_id) references players (id)
        match simple on update no action on delete no action
);

create table shootouts
(
    id               bigint primary key not null,
    game_id          bigint,
    first_shooter_id bigint,
    winner_id        bigint,
    foreign key (first_shooter_id) references countries (id)
        match simple on update no action on delete no action,
    foreign key (game_id) references games (id)
        match simple on update no action on delete no action
);

