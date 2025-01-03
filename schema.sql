create table if not exists cache
(
    `key`      varchar(255) not null
        primary key,
    value      mediumtext   not null,
    expiration int          not null
)
    collate = utf8mb4_unicode_ci;

create table if not exists cache_locks
(
    `key`      varchar(255) not null
        primary key,
    owner      varchar(255) not null,
    expiration int          not null
)
    collate = utf8mb4_unicode_ci;

create table if not exists categories
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(255) not null,
    description text         null,
    created_at  timestamp    null,
    updated_at  timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table if not exists failed_jobs
(
    id         bigint unsigned auto_increment
        primary key,
    uuid       varchar(255)                        not null,
    connection text                                not null,
    queue      text                                not null,
    payload    longtext                            not null,
    exception  longtext                            not null,
    failed_at  timestamp default CURRENT_TIMESTAMP not null,
    constraint failed_jobs_uuid_unique
        unique (uuid)
)
    collate = utf8mb4_unicode_ci;

create table if not exists job_batches
(
    id             varchar(255) not null
        primary key,
    name           varchar(255) not null,
    total_jobs     int          not null,
    pending_jobs   int          not null,
    failed_jobs    int          not null,
    failed_job_ids longtext     not null,
    options        mediumtext   null,
    cancelled_at   int          null,
    created_at     int          not null,
    finished_at    int          null
)
    collate = utf8mb4_unicode_ci;

create table if not exists jobs
(
    id           bigint unsigned auto_increment
        primary key,
    queue        varchar(255)     not null,
    payload      longtext         not null,
    attempts     tinyint unsigned not null,
    reserved_at  int unsigned     null,
    available_at int unsigned     not null,
    created_at   int unsigned     not null
)
    collate = utf8mb4_unicode_ci;

create index jobs_queue_index
    on jobs (queue);

create table if not exists migrations
(
    id        int unsigned auto_increment
        primary key,
    migration varchar(255) not null,
    batch     int          not null
)
    collate = utf8mb4_unicode_ci;

create table if not exists password_reset_tokens
(
    email      varchar(255) not null
        primary key,
    token      varchar(255) not null,
    created_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table if not exists sessions
(
    id            varchar(255)    not null
        primary key,
    user_id       bigint unsigned null,
    ip_address    varchar(45)     null,
    user_agent    text            null,
    payload       longtext        not null,
    last_activity int             not null
)
    collate = utf8mb4_unicode_ci;

create index sessions_last_activity_index
    on sessions (last_activity);

create index sessions_user_id_index
    on sessions (user_id);

create table if not exists users
(
    id                bigint unsigned auto_increment
        primary key,
    name              varchar(255)                                      not null,
    email             varchar(255)                                      not null,
    email_verified_at timestamp                                         null,
    password          varchar(255)                                      not null,
    role              enum ('admin', 'seller', 'buyer') default 'buyer' not null,
    remember_token    varchar(100)                                      null,
    created_at        timestamp                                         null,
    updated_at        timestamp                                         null,
    constraint users_email_unique
        unique (email)
)
    collate = utf8mb4_unicode_ci;

create table if not exists addresses
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned      not null,
    title      varchar(255)         not null,
    address    text                 not null,
    city       varchar(255)         not null,
    district   varchar(255)         not null,
    phone      varchar(255)         not null,
    is_default tinyint(1) default 0 not null,
    created_at timestamp            null,
    updated_at timestamp            null,
    constraint addresses_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table if not exists products
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(255)    not null,
    description text            not null,
    price       decimal(10, 2)  not null,
    stock       int             not null,
    category_id bigint unsigned not null,
    user_id     bigint unsigned not null,
    created_at  timestamp       null,
    updated_at  timestamp       null,
    constraint products_category_id_foreign
        foreign key (category_id) references categories (id),
    constraint products_user_id_foreign
        foreign key (user_id) references users (id)
)
    collate = utf8mb4_unicode_ci;

create table if not exists carts
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned not null,
    product_id bigint unsigned not null,
    quantity   int default 1   not null,
    created_at timestamp       null,
    updated_at timestamp       null,
    constraint carts_product_id_foreign
        foreign key (product_id) references products (id)
            on delete cascade,
    constraint carts_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table if not exists favorites
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned not null,
    product_id bigint unsigned not null,
    created_at timestamp       null,
    updated_at timestamp       null,
    constraint favorites_user_id_product_id_unique
        unique (user_id, product_id),
    constraint favorites_product_id_foreign
        foreign key (product_id) references products (id)
            on delete cascade,
    constraint favorites_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table if not exists product_images
(
    id         bigint unsigned auto_increment
        primary key,
    product_id bigint unsigned not null,
    image_path varchar(255)    not null,
    `order`    int default 0   not null,
    created_at timestamp       null,
    updated_at timestamp       null,
    constraint product_images_product_id_foreign
        foreign key (product_id) references products (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

