﻿using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Terraria;

namespace StarlightRiver.Content.Tiles.Underground.WitShrineGames
{
	class MazeGame : WitShrineGame
	{
		public MazeGame(WitShrineDummy parent) : base(parent) { }

		public override void SetupBoard()
		{
			for (int x = 0; x < gameBoard.GetLength(0); x++)
				for (int y = 0; y < gameBoard.GetLength(1); y++)
				{
					if (Main.rand.Next(3) == 0)
						gameBoard[x, y] = WitShrineDummy.runeState.HostileHidden;
				}
		}

		public override void UpdatePlayer(Vector2 player, Vector2 oldPlayer)
		{
			for (int x = Clamp(oldPlayer.X - 1); x <= Clamp(oldPlayer.X + 1); x++)
				for (int y = Clamp(oldPlayer.Y - 1); y <= Clamp(oldPlayer.Y + 1); y++)
				{
					if (gameBoard[x, y] == WitShrineDummy.runeState.Hostile)
						gameBoard[x, y] = WitShrineDummy.runeState.HostileHidden;
				}

			for (int x = Clamp(player.X - 1); x <= Clamp(player.X + 1); x++)
				for (int y = Clamp(player.Y - 1); y <= Clamp(player.Y + 1); y++)
				{
					if (gameBoard[x, y] == WitShrineDummy.runeState.HostileHidden)
						gameBoard[x, y] = WitShrineDummy.runeState.Hostile;
				}

			if (gameBoard[(int)oldPlayer.X, (int)oldPlayer.Y] == WitShrineDummy.runeState.None)
				gameBoard[(int)oldPlayer.X, (int)oldPlayer.Y] = WitShrineDummy.runeState.Freindly;

			if (gameBoard[(int)player.X, (int)player.Y] == WitShrineDummy.runeState.Hostile)
				parent.LoseGame();

			for (int x = 0; x < 6; x++)
				for (int y = 0; y < 6; y++)
				{
					if (gameBoard[x, y] == WitShrineDummy.runeState.None)
						return;
				}

			parent.WinGame();
		}
	}
}