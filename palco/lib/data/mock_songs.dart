import '../models/song.dart';

const mockSongs = [
  Song(
    id: 1,
    title: 'Hallelujah',
    artist: 'Leonard Cohen',
    originalKey: 'C',
    bpm: 64,
    chordSheet: '''[C]I've heard there [Am]was a secret [C]chord
[C]That David [Am]played, and it [F]pleased the Lord
But [F]you don't really [C]care for music, [G]do you?
[C]It goes like [F]this: the [G]fourth, the [C]fifth
The [Am]minor fall, the [F]major lift
The [G]baffled king com[Am]posing Halle[G]lujah

[F]Hallelujah, [Am]Hallelujah
[F]Hallelujah, [G]Halle[C]lujah
[F]Hallelujah, [Am]Hallelujah
[F]Hallelujah, [G]Halle[C]lujah''',
  ),
  Song(
    id: 2,
    title: 'Pais e Filhos',
    artist: 'Legião Urbana',
    originalKey: 'E',
    bpm: 75,
    chordSheet: '''[E]Devia ter amado [A]mais
[E]Ter chorado [B]mais
[E]Ter visto o [C#m]sol nascer [A]
[E]Devia ter arris[A]cado mais
[E]E até errado [B]mais
[E]Ter feito o que [C#m]eu queria [A]fazer

[A]Quem me dera ao menos uma [E]vez
[A]Ter tido sua [B]força em minhas [E]mãos
[A]Ter jogado fora toda [E]a cautela
[A]E de fato entrado [B]de cabeça em [E]cada ilusão

[C#m]Mas as noites [A]vão
[E]As noites [B]vão, sempre [C#m]iguais
[A]Obstinadas [E]a negar
[A]Que existe a [B]solução [E]pra vida''',
  ),
  Song(
    id: 3,
    title: 'Stand by Me',
    artist: 'Ben E. King',
    originalKey: 'A',
    bpm: 116,
    chordSheet: '''[A]When the night has come
And the land is [F#m]dark
And the moon is the [D]only light we'll [E]see
[A]No I won't be afraid
No I [F#m]won't be afraid
Just as [D]long as you stand, [E]stand by [A]me

[A]So darling, darling [F#m]stand by me
Oh [D]stand by me
Oh [E]stand, stand by [A]me
Stand by [F#m]me
Oh [D]stand by me
Oh [E]stand, stand by [A]me''',
  ),
];
