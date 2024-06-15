


def char_is_digit(char) -> bool:
    """
    Check if a single charstr is a digit.
    """
    # Check if char is a digit
    if char == "0": return True # lol - check what the compiler does here...
    if char == "1": return True # lol
    if char == "2": return True # lol
    if char == "3": return True # lol
    if char == "4": return True # lol
    if char == "5": return True # lol
    if char == "6": return True # lol
    if char == "7": return True # lol
    if char == "8": return True # lol
    if char == "9": return True # lol
    return False


def print_pretty_bitmask(bitmask):
    """
    Print a pretty representation of a bitmask.
    Orientation is white at the bottom, black at the top.\n
    0 0 0 0 0 0 0 0\n
    0 0 0 0 0 0 0 0\n
    0 0 0 0 0 0 0 0\n
    0 0 0 0 0 0 0 0\n
    0 0 0 0 0 0 0 0\n
    0 0 0 0 0 0 0 0\n
    0 0 0 0 0 0 0 0\n
    1 0 0 0 0 0 0 1\n
    Example of two white rooks on a1 and h1.
    """
    bm = ""
    for rank in range(7, -1, -1):
        for file in range(8):
            piece = 1 << (rank * 8 + file)
            if bitmask & piece:
                bm += "1 "
            else:
                bm += "0 "
        bm += "\n"
    print(bm)


def get_bitmask_string(bitmask) -> str:
    """
   str binary representation of a 64-bit bitmask.
    Example: 0000000011111111000000001111111100000000111111110000000011111111.
    """
    bm:str = ""
    for rank in range(int(7), int(-1), int(-1)):
        for file in range(int(8)):
            piece: int = 1 << (rank * 8 + file)
            if bitmask & piece:
                bm += "1"
            else:
                bm += "0"
    return bm

# --------------------------------------------------------------------------------

# Define Board
class Board:
    # --- Properties ---

    # Bitmask of white pieces and black pieces
    bitmask_white_pawn: int
    bitmask_white_knight: int
    bitmask_white_bishop: int
    bitmask_white_rook: int
    bitmask_white_queen: int
    bitmask_white_king: int
    bitmask_black_pawn: int
    bitmask_black_knight: int
    bitmask_black_bishop: int
    bitmask_black_rook: int
    bitmask_black_queen: int
    bitmask_black_king: int


    # --- Specials ---

    # Constructor
    def __init__(self):
        self.bitmask_white_pawn = 0
        self.bitmask_white_knight = 0
        self.bitmask_white_bishop = 0
        self.bitmask_white_rook = 0
        self.bitmask_white_queen = 0
        self.bitmask_white_king = 0
        self.bitmask_black_pawn = 0
        self.bitmask_black_knight = 0
        self.bitmask_black_bishop = 0
        self.bitmask_black_rook = 0
        self.bitmask_black_queen = 0
        self.bitmask_black_king = 0

    # __str__ overload
    def __str__(self) ->str:
        board:str = ""
        for rank in range(int(7), int(-1), int(-1)):
            for file in range(int(8)):
                piece: int = 1 << (rank * 8 + file)
                if self.bitmask_white_pawn & piece:
                    board += "P "
                elif self.bitmask_white_knight & piece:
                    board += "N "
                elif self.bitmask_white_bishop & piece:
                    board += "B "
                elif self.bitmask_white_rook & piece:
                    board += "R "
                elif self.bitmask_white_queen & piece:
                    board += "Q "
                elif self.bitmask_white_king & piece:
                    board += "K "
                elif self.bitmask_black_pawn & piece:
                    board += "p "
                elif self.bitmask_black_knight & piece:
                    board += "n "
                elif self.bitmask_black_bishop & piece:
                    board += "b "
                elif self.bitmask_black_rook & piece:
                    board += "r "
                elif self.bitmask_black_queen & piece:
                    board += "q "
                elif self.bitmask_black_king & piece:
                    board += "k "
                else:
                    board += "  "
            board += "\n"
        return board


    # --- Methods ---


    # Reset pieces bitmasks
    def reset_bitmasks_pieces(self): # inout required to grant mutability
        self.bitmask_white_pawn = 0
        self.bitmask_white_knight = 0
        self.bitmask_white_bishop = 0
        self.bitmask_white_rook = 0
        self.bitmask_white_queen = 0
        self.bitmask_white_king = 0
        self.bitmask_black_pawn = 0
        self.bitmask_black_knight = 0
        self.bitmask_black_bishop = 0
        self.bitmask_black_rook = 0
        self.bitmask_black_queen = 0
        self.bitmask_black_king = 0

    # Load board FEN (only board part, i.e. up to the first space)
    def load_fen_board(self, fen:str):
        # Reset pieces bitmasks
        self.reset_bitmasks_pieces()

        # Extract board part from FEN
        board_fen:str = ""
        try:
            board_fen = fen.split(" ")[0]
        except:
            raise Exception("Invalid FEN format") # functions must be flagged as to propagate exceptions (?)
        
        # Parse board FEN
        rank: int = 7
        file: int = 0
        char:str
        for i in range(len(board_fen)):
            char = board_fen[i]
            if char == "/":
                rank -= 1
                file = 0
            else:
                if char_is_digit(char):
                    file += int(char) # atol convertsstr to int
                else:
                    piece: int = 1 << (rank * 8 + file)
                    if char == "P":
                        self.bitmask_white_pawn |= piece
                    elif char == "N":
                        self.bitmask_white_knight |= piece
                    elif char == "B":
                        self.bitmask_white_bishop |= piece
                    elif char == "R":
                        self.bitmask_white_rook |= piece
                    elif char == "Q":
                        self.bitmask_white_queen |= piece
                    elif char == "K":
                        self.bitmask_white_king |= piece
                    elif char == "p":
                        self.bitmask_black_pawn |= piece
                    elif char == "n":
                        self.bitmask_black_knight |= piece
                    elif char == "b":
                        self.bitmask_black_bishop |= piece
                    elif char == "r":
                        self.bitmask_black_rook |= piece
                    elif char == "q":
                        self.bitmask_black_queen |= piece
                    elif char == "k":
                        self.bitmask_black_king |= piece
                    else:
                        raise "Invalid piece in FEN"
                    file += 1
    
    # Get board FEN
    def get_fen_board(self) -> str:
        """
        Convert the board bitmasks back into the FENstr representation.
        """
        fen:str = ""
        for rank in range(int(7), int(-1), int(-1)):
            empty_count: int = 0
            for file in range(int(8)):
                piece: int = 1 << (rank * 8 + file)
                piece_char:str = ""
                if self.bitmask_white_pawn & piece:
                    piece_char = "P"
                elif self.bitmask_white_knight & piece:
                    piece_char = "N"
                elif self.bitmask_white_bishop & piece:
                    piece_char = "B"
                elif self.bitmask_white_rook & piece:
                    piece_char = "R"
                elif self.bitmask_white_queen & piece:
                    piece_char = "Q"
                elif self.bitmask_white_king & piece:
                    piece_char = "K"
                elif self.bitmask_black_pawn & piece:
                    piece_char = "p"
                elif self.bitmask_black_knight & piece:
                    piece_char = "n"
                elif self.bitmask_black_bishop & piece:
                    piece_char = "b"
                elif self.bitmask_black_rook & piece:
                    piece_char = "r"
                elif self.bitmask_black_queen & piece:
                    piece_char = "q"
                elif self.bitmask_black_king & piece:
                    piece_char = "k"
                else:
                    empty_count += 1
                
                if piece_char != "":
                    if empty_count > 0:
                        fen += str(empty_count)
                        empty_count = 0
                    fen += piece_char
            
            if empty_count > 0:
                fen += str(empty_count)
            
            if rank > 0:
                fen += "/"
        
        return fen
    

    # Get bitmasks
    def get_bitmask_white_pawn(self) -> int:
        return self.bitmask_white_pawn
    def get_bitmask_white_knight(self) -> int:
        return self.bitmask_white_knight
    def get_bitmask_white_bishop(self) -> int:
        return self.bitmask_white_bishop
    def get_bitmask_white_rook(self) -> int:
        return self.bitmask_white_rook
    def get_bitmask_white_queen(self) -> int:
        return self.bitmask_white_queen
    def get_bitmask_white_king(self) -> int:
        return self.bitmask_white_king

    def get_bitmask_black_pawn(self) -> int:
        return self.bitmask_black_pawn
    def get_bitmask_black_knight(self) -> int:
        return self.bitmask_black_knight
    def get_bitmask_black_bishop(self) -> int:
        return self.bitmask_black_bishop
    def get_bitmask_black_rook(self) -> int:
        return self.bitmask_black_rook
    def get_bitmask_black_queen(self) -> int:
        return self.bitmask_black_queen
    def get_bitmask_black_king(self) -> int:
        return self.bitmask_black_king

    def get_bitmask_white_pieces(self) -> int:
        return self.bitmask_white_pawn | self.bitmask_white_knight | self.bitmask_white_bishop | self.bitmask_white_rook | self.bitmask_white_queen | self.bitmask_white_king

    def get_bitmask_black_pieces(self) -> int:
        return self.bitmask_black_pawn | self.bitmask_black_knight | self.bitmask_black_bishop | self.bitmask_black_rook | self.bitmask_black_queen | self.bitmask_black_king

    def get_bitmask_all_pieces(self) -> int:
        return self.get_bitmask_white_pieces() | self.get_bitmask_black_pieces()

    def get_bitmask_empty_squares(self) -> int:
        return ~self.get_bitmask_all_pieces()
