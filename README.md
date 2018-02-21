FightChess
==========
Real-time chess. 

Rules 规则介绍:

- Goals

  The goal of FightChess is to eliminate the enemy King.
  游戏目标是消灭对方的国王。

- Attack and Defense 攻击和守护

  The chess pieces move just like they did in traditional chess games. The different part is that the pieces don't take out their enemies, instead, they automatically attack the enemies. And instead of being blocked by allies, your pieces can heal or give shield to your other pieces.
  棋子的移动和攻击方法和传统国际象棋相同。不同的是，当一个棋子处在可以吃敌人棋子的位置时，它不是直接把敌人吃掉，而是在原地自动攻击它们。如果那些棋子是友军，它就不会攻击，而是给友军增加护盾或恢复生命。
  
- HP and Shield 血和盾

  Each piece has HP (indicated by the bar above the piece) and shield (indicated by the translucent blue grid). When a piece is attacked, its shield level drops. When it's got no shield left, HP level will start to drop. Pieces will die if their HP drop below zero.
  每个棋子都有血（棋子上方的长条）和盾（半透明的蓝色方格）。受到攻击时，盾会下降，如果盾已经为零，就会扣血，血扣光了就死了。

- Spawning and Promotion 刷兵和升变

  A Pawn spawns every a few seconds depending on how many pieces you have left on board. The fewer pieces, the quicker the spawning. When a Pawn is pushed all the way through the enemy line, it gets promoted to the Super Pawn, marked with a capital S. The Super Pawn moves like the King and strikes in four directions. When a Super Pawn has made the return trip back to the lowest rank (row) of your side, it gets promoted again to one of the four kinds of pieces: Rook, Knight, Bishop or Queen, depending on the file (column) it reaches.
  每隔几十秒双方就会各刷一个兵，一方的棋子越少，刷兵就越快。当兵一直向前走到对方阵营的底线时，就会升级成超级兵，以一颗星标注。超级兵像王一样移动，并且可以朝四个方向攻击。当超级兵一直往回走，到达己方阵营底线的时候，就会再次升变成车、马、象、后这四个棋子之一，变成哪个则取决于到达时在哪一列。

- Data

1. Basic Statistics

```
                hp  shield   shield recover speed   move cooldown   self-healing speed
                                (per second)           (second)         (per second)
  king        1000       3            3                   6                 1
  queen        100      50            1                   5                 3
  rook         600       5            1                   9                 0
  bishop       450       1            1                   6                 0
  knight       400       1            1                   5                 0
  pawn         240       0            0                   8                 0
  super_pawn   300       0            0                   7                 0
```

2. Attacking Enemies

```
                attack damage    attack cooldown    average attack damage
                                    (second)           (per second)
  king                3                  5                   6
  queen               3                 20                   1.5
  rook               20                 30                   6.7
  bishop             12                 20                   6
  knight              3                  6                   5
  pawn                6                 12                   5
  super_pawn          7                 15                   4.7



```

3. Supporting Allies

```
            shield limit increase    shield recover speed increase    hp recover speed increase
                                            (per second)                    (per second)
  king               2                           1                              1                             
  queen             10                           0                              1                            
  rook               1                           1                              0                             
  bishop             1                           1                              0                             
  knight             1                           1                              0                             
  pawn               1                           1                              0                             
  super_pawn         1                           1                              0                             
```


- Hints

1. This game only supports Chrome.
2. To play with your peer, you and your peer will need to log in with a username first, then you can type in your peer's username and click "challenge". The connection should be established automatically and you will be the guest playing black, your peer being the host playing white. The game will be started after the host clicks the "start game" button. After logging in, you can not log in again with the same username in a few minutes.
3. The monkey AI moves randomly.
4. Adjust the positions of your pieces to let them protect each other, and focus your fire on some of the enemy pieces to eliminate them quickly.
5. Make use of the powerful King to attack enemy pawns and heal your pieces. The Queen is vulnerable but is born with a high shield and recovers fast - hide it behind the front line to heal and increase the shield limit for your pieces.
6. Clear enemies that are blocking your pawns and don't forget to advance your pawns. When they got promoted to super pawns, remember to retreat them and promote again.
7. Enjoy it well.