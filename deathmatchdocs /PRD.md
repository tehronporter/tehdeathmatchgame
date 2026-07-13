# PRD — Deathmatch Arena
### Version 1.0 (MVP) — PS1-nostalgic physics fighting game for iPhone, built with Claude Code

## 1. Vision
A fun, over-the-top, low-poly arcade fighting game inspired by classic PS1-era
wrestling and fighting games. Emphasis on fast gameplay, physics comedy, and
stylized characters — not realism. Matches last ~90–180 seconds, built for
mobile session lengths.

Reference feel: Celebrity Deathmatch × WWF Attitude × Power Stone × Gang Beasts
× Smash Bros (casual, not competitive-deep).

## 2. Design philosophy
Simple. Funny. Fast. Easy to master. Impossible not to laugh.
Target: someone opens the app and is fighting within 10 seconds.

## 3. Legal/IP approach
No real celebrities or licensed likenesses (avoids cost + legal risk). Instead:
- Original parody archetypes inspired by pop-culture *types*, not individuals.
- A character creator for player-built fighters.
- (Stretch) AI-"clayified" selfie-to-character tool for social sharing.
- Weekly themed events introducing new parody archetypes over time.

This preserves the spirit of the original pitch while keeping the project
legally and financially viable for an indie build, and creates a natural
user-generated-content loop for TikTok/Reels/Shorts sharing.

## 4. Genre & Core Loop
1v1 arcade fighter, physics-based combat, short matches, built for one-handed
mobile play.

```
Open App → Daily Reward → Quick Match → 2-Minute Fight →
Unlock Cosmetic → Share Funny Replay → Queue Again
```

## 5. Controls
- Left thumb: virtual joystick (movement)
- Right thumb: 4 buttons — Punch, Kick, Grab, Special
- No combo inputs. No gestures. One-handed play should be possible if needed.

## 6. Visual style
- PS1-era low-poly aesthetic, intentionally retro
- Low-poly characters (500–1,500 tris), simple textures
- Modern lighting, smooth/high framerate animation (target 60fps gameplay)
- Clay-like materials; oversized heads, exaggerated hands, tiny bodies,
  expressive faces
- Cartoon blood/impact effects — exaggerated slapstick, never graphic

> See ARCHITECTURE.md — the rendering approach to actually achieve this look
> in a React Native/Expo pipeline is an open decision, not yet settled.

## 7. Health / Meter system
Three meters per fighter:
- ❤️ Health
- ⚡ Stamina
- ⭐ Hype — fills as the crowd cheers during a match; spend it on finishers

## 8. Finishers
Comedic, exaggerated, arena-triggered or Hype-triggered special kills. Never
graphic — cartoon slapstick only. Examples: dropped piano, giant boxing glove
from the ceiling, shark jumps into the ring, alien abduction, meteor strike,
TNT pile, wrestling chair from the announcer, rocket launch, exploding ring.

## 9. Arenas (MVP ships with 6)
Every arena has an environmental hazard:

| Arena | Hazard |
|---|---|
| Warehouse | Moving cranes, explosive barrels |
| TV Studio | Falling lights, swinging camera cranes |
| Vegas Rooftop | Helicopter wind, billboards |
| Junkyard | Cars, tires, magnets |
| Wrestling Ring | Ropes, crowd, thrown chairs |
| Construction Site | Cement mixers, cranes, falling pipes |

(Original pitch also considered Movie Studio, Las Vegas floor, Music Festival,
Space Station — good candidates for post-MVP arena drops.)

## 10. Characters
Each character has 4 stats only — Health, Strength, Speed, Special. No RPG
depth beyond that. MVP ships with 10 original parody archetypes (see
GAME_DESIGN.md for the full roster and stat spreads):

The Action Hero, The Pop Diva, The Tech Billionaire, The Influencer, The
Rockstar, The Wrestler, The Conspiracy Host, The Chef, The Billionaire, The
Super Fan.

## 11. Career Mode
Start as an Unknown Influencer → fight through Actors, Musicians, Athletes,
Politicians, and fictional parody archetypes → headline "The Deathmatch
Awards."

## 12. Multiplayer (post-prototype)
- Ranked 1v1
- Casual Quick Match
- Friends / private rooms
- 8-player bracket tournaments, cosmetic rewards for winners

## 13. Progression
XP, levels, coins. Unlocks: outfits, entrance animations, victory dances,
finishers, voice packs. Cosmetic only — **no gameplay advantages, ever.**

Daily challenges (e.g. win 3 matches, land 100 punches, perform 5 finishers,
win without losing) and achievements (100 wins, 500 punches, first finisher,
perfect match, win streaks). Leaderboards: global, friends, country, seasonal.

## 14. Weekly events (post-prototype)
Themed rotations introducing new archetypes/arenas — e.g. "Internet Week"
(parody influencers), "90s Week" (retro characters), "Action Movie Week"
(explosive arena).

## 15. Social / sharing (post-prototype)
Replay system with one-tap share of knockouts, finishers, funniest ragdoll
moments. Auto-export as vertical video for TikTok/Reels/Shorts.

## 16. Create-a-Fighter (stretch goal)
Player uploads a selfie → AI generates a low-poly, PS1-style, cartoon-proportioned
character → player customizes hairstyle, outfit, fighting style, voice, special
move. High UGC/virality potential, but deferred: requires an image-generation
pipeline and needs care around processing photos of real people (the player's
own likeness is fine; the tool shouldn't be usable to generate characters from
photos of other people without consent).

## 17. Monetization
Free to download. Revenue from: Battle Pass, cosmetic skins, finishers, emotes,
ring themes, character intros. **No pay-to-win, full stop.**

## 18. Art direction
UI feels like "late-90s MTV reimagined for today": black backgrounds, chrome
borders, electric blue accents, CRT scanline effects, grungy textures, thick
arcade fonts, loud crowd chants.

## 19. Performance targets
- 60 FPS gameplay
- Under 500MB install size
- Cold load under 5 seconds
- Supported range: iPhone SE through newest iPhone

## 20. Platform
iOS first (Expo managed → EAS build → TestFlight). Android considered later,
not in MVP scope.

## 21. MVP scope (what "prototype" means for this project)
The prototype is done when:
- One arena, two playable characters, local vs-AI matches work.
- Full control scheme (joystick + 4 buttons) is functional and feels good.
- Physics-based hits, stumble/ragdoll/knockback are working.
- Health + Stamina meters function; at least one Hype-triggered finisher works
  end-to-end (trigger → animation/effect → match-ending state).
- A match can be played start-to-finish (menu → fight → winner screen → replay)
  at a stable framerate on a real device.

Everything past this (multiplayer, Supabase, progression, cosmetics, weekly
events, Create-a-Fighter) is explicitly **post-prototype** — see BUILD_PLAN.md.

## 22. Success metrics (MVP)
- App launches in under 5 seconds.
- New players can start a match within 10 seconds.
- Average match length ≈ 2 minutes.
- Stable 60 FPS on modern iPhones.
- Core gameplay is fun with only 4 action buttons.
- Zero pay-to-win mechanics.
- Retro aesthetic reads as intentional, not outdated.
