FightChess
==========

It's chess. It's live.


Rules 规则介绍:

- Attack and Defense 攻击和守护

  In FightChess, the chess pieces move just like they did in traditional chess games. The difference is that the pieces don't go around taking out other pieces as in the old ways, instead, they automatically attack the pieces in reach when they are in the position to take out them. But if the piece in reach is an ally, it is going to defend it instead.
  在 FightChess 中，棋子的移动方法和传统国际象棋是相同的。和传统象棋玩法的区别在于，当一个棋子处在可以吃其它棋子的位置时，它不能像原来那样直接把其它棋子吃掉，而是在原地自动攻击它们。但如果那些棋子是己方棋子的话，它就不会攻击，而是会去守护它们。
  
- HP and Shield 血和盾

  Each piece has an HP indicator and a shield indicator that indicate their health conditions. When a piece is attacked, its shield level drops. But if it has no shield or when its shield level has dropped to zero, its begins to lose HP. If the HP level drops below zero, it dies and clears out of the board.
  每个棋子都有血条和盾条，表示这个棋子的健康状况。当一个棋子被攻击时，它的盾会下降，如果它没有盾或者盾已经降到零，那么它就会开始扣血了。要是血扣光了，棋子就会死去，从棋盘上消失。
  
- Assistance 辅助
  
  Once the HP level of a piece begins to reduce, there is no way to get it back up again. In contrast, the shield of a piece can always recover in a specific rate. The recovery rate is determined by the piece type, and by the pieces that are defending it. For example, a Rook is born with a shield level of 3 and a shield recovery rate of 3 every second. If the Rook is defended by a Knight, it gains a shield limit increase of 2 and a recovery rate increase of 1, which makes it a Rook with a shield level upper limit of 5 and a shield recovery rate of 4/s. The ability of a piece to provide extra shield and recovery rate to its allies is called assistance. the Queen and the King are the pieces that comes with the greatest assistance abilities.
  棋子的血一旦下降，就没有办法再恢复了。与之相反，棋子的盾会以一个恒定的速率恢复（简称盾速），这个速率取决于棋子本身的类型，以及正在守护这个棋子的其它棋子。比如，车天生有 3 个盾，并且盾速是 3 每秒。如果有一个马守护这个车，就可以为车增加 2 个盾上限和 1 个盾速，这样车就有 5 个盾上限和 4 每秒的盾速。给己方棋子增加盾上限和盾速的能力叫辅助能力。皇后和王的辅助能力是最强的。
  
- Tactics 战术信息

  The pieces fit best for different tactical positions. The King brings the highest attack damage (8/s) to others, following the King are the Rook (7/s), the Bishop (6/s), the Knight (5/s), the Pawn (4/s), and the Queen (3/s). The Rook has the highest amount of HP and the longest attack cool-down (cd) and move cd, 3s and 7s, respectively, which means it is going to take the longest for a Rook to attack or move again since the last time it attacked or moved, typical for a piece that is strong and clumsy. The piece with the best agility is the Knight, with a attack cd of 0.5s and a move cd of 2s.
  所有棋子在战术使用上各有优缺点。王的攻击能力是最强的（8 每秒），其次是车（7），象（6），马（5），兵（4），后（3）。车有最高的血量，和最长的攻击间隔和移动间隔（即每次攻击或移动后，能够再次进行攻击或移动的时间间隔），分别是 3 秒和 7 秒，这使得车的动作显得有力却笨拙。在敏捷方面表现最好的是马，分别是 0.5 秒的攻击间隔和 2 秒的移动间隔。
  
- Promotion 升变

  The Pawn is a special kind of piece that has the potential power to turn the game over. Its low amount of HP, lack of inborn shield and never-going-backwards moving style makes it a piece of very little usage except for absorbing damages. But whenever a Pawn has made all the way to the other side and touched the bottom line of the battle field, it gets promoted to the Super Pawn. The Super Pawn can go and strike in four directions. And whenever a Super Pawn has made the return trip to the bottom line of its own side, it gets promoted again to one of the four kinds of pieces: Rook, Knight, Bishop or Queen, depending on the column it is on by the time of promotion.
  兵是一种可以扭转战局的特别兵种。它没有天生的盾，血量也很少，而且只能往前走，在战斗初期只能充当肉盾。但是，当兵一直向前走到对方阵营的底线时，就会升级成超级兵。超级兵可以朝四个方向行走和攻击。当超级兵一直往回走，到达己方阵营底线的时候，就会根据到达的位置再次升变成车、马、象、后这四个棋子之一。
