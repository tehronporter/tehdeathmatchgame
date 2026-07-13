create table profiles (
  id uuid primary key references auth.users (id),
  username text unique not null,
  created_at timestamptz not null default now(),
  xp integer not null default 0,
  level integer not null default 1,
  coins integer not null default 0
);

create table characters_unlocked (
  profile_id uuid references profiles (id),
  character_id text not null,
  unlocked_at timestamptz not null default now(),
  primary key (profile_id, character_id)
);

create table cosmetics_owned (
  profile_id uuid references profiles (id),
  cosmetic_id text not null,
  unlocked_at timestamptz not null default now(),
  primary key (profile_id, cosmetic_id)
);

create table matches (
  id uuid primary key default gen_random_uuid(),
  player_a uuid references profiles (id),
  player_b uuid references profiles (id),
  winner uuid references profiles (id),
  arena_id text not null,
  duration integer not null,
  created_at timestamptz not null default now()
);

create table leaderboard (
  profile_id uuid references profiles (id),
  rank integer not null,
  wins integer not null default 0,
  season text not null,
  primary key (profile_id, season)
);

create table achievements (
  profile_id uuid references profiles (id),
  achievement_id text not null,
  earned_at timestamptz not null default now(),
  primary key (profile_id, achievement_id)
);

alter table profiles enable row level security;
alter table characters_unlocked enable row level security;
alter table cosmetics_owned enable row level security;
alter table matches enable row level security;
alter table leaderboard enable row level security;
alter table achievements enable row level security;

create policy "profiles are self-readable" on profiles for select using (auth.uid() = id);
create policy "profiles are self-writable" on profiles for update using (auth.uid() = id);
