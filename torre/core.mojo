from bit import byte_swap
from builtin.string import isdigit


fn get_start_fen() -> StringLiteral:
    return "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

fn get_start_fen_board_only() -> StringLiteral:
    return "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

fn print_pretty_bitmask(bitmask: UInt64):
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
    var bm: String = ""
    for rank in range(UInt64(7), UInt64(-1), UInt64(-1)):
        for file in range(UInt64(8)):
            var piece: UInt64 = 1 << (rank * 8 + file)
            if bitmask & piece:
                bm += "1 "
            else:
                bm += "0 "
        bm += "\n"
    print(bm)

fn get_bitmask_string(bitmask: UInt64, byte_sep: String = "_") -> String: # TODO: can do better than this :D
    """
    String binary representation of a 64-bit bitmask.
    Example: 0000000011111111000000001111111100000000111111110000000011111111.
    """
    var bm: String = "" # this is fixed len always 64 chars
    for rank in range(UInt64(7), UInt64(-1), UInt64(-1)):
        for file in range(UInt64(8)):
            var piece: UInt64 = 1 << (rank * 8 + file)
            if bitmask & piece:
                bm += "1"
            else:
                bm += "0"
        bm += byte_sep
    return bm.strip("_") # avoid calling strip here

# --------------------------------------------------------------------------------

# Define Board
struct Board:
    """
    Carries the same exact information contained in a FEN string.
    A FEN string contains up to 6 fields separated by spaces:
    1. Piece placement (from rank 8 to rank 1, from file a to file h)
    2. Active color (w or b)
    3. Castling availability (KQkq or -)
    4. En passant target square (in algebraic notation, or -)
    5. Halfmove clock (number of halfmoves since the last capture or pawn advance)
    6. Fullmove number (starts at 1, incremented after black's move).
    """

    # Bitmask of white pieces and black pieces
    var bitmask_white_pawn: UInt64
    var bitmask_white_knight: UInt64
    var bitmask_white_bishop: UInt64
    var bitmask_white_rook: UInt64
    var bitmask_white_queen: UInt64
    var bitmask_white_king: UInt64
    var bitmask_black_pawn: UInt64
    var bitmask_black_knight: UInt64
    var bitmask_black_bishop: UInt64
    var bitmask_black_rook: UInt64
    var bitmask_black_queen: UInt64
    var bitmask_black_king: UInt64

    # Active color
    var active_color: Bool # True for white, False for black

    # Castling rights
    var castling_rights_white_kingside: Bool
    var castling_rights_white_queenside: Bool
    var castling_rights_black_kingside: Bool
    var castling_rights_black_queenside: Bool

    # Bitmask for en passant square
    var bitmask_en_passant: UInt64

    # Clocks
    var halfmove_clock: UInt16
    var fullmove_number: UInt16

    # Constructor
    fn __init__(inout self):
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
        self.active_color = 0
        self.castling_rights_white_kingside = 0
        self.castling_rights_white_queenside = 0
        self.castling_rights_black_kingside = 0
        self.castling_rights_black_queenside = 0
        self.bitmask_en_passant = 0
        self.halfmove_clock = 0
        self.fullmove_number = 0

        # Reset board to start FEN
        self.reset_start_fen()

    
    # Constructor overload that takes a FEN string
    fn __init__(inout self, fen: String) raises:
        self.__init__()
        self.load_fen(fen)

    # __str__ overload
    fn __str__(self) -> String:
        var board: String = ""
        for rank in range(UInt64(7), UInt64(-1), UInt64(-1)):
            for file in range(UInt64(8)):
                var piece: UInt64 = 1 << (rank * 8 + file)
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
    
    # Reset board
    fn reset_start_fen(inout self):
        self.bitmask_white_pawn = 65280
        self.bitmask_white_knight = 66
        self.bitmask_white_bishop = 36
        self.bitmask_white_rook = 129
        self.bitmask_white_queen = 8
        self.bitmask_white_king = 16
        self.bitmask_black_pawn = 71776119061217280
        self.bitmask_black_knight = 4755801206503243776
        self.bitmask_black_bishop = 2594073385365405696
        self.bitmask_black_rook = 9295429630892703744
        self.bitmask_black_queen = 576460752303423488
        self.bitmask_black_king = 1152921504606846976
        self.active_color = True
        self.castling_rights_white_kingside = True
        self.castling_rights_white_queenside = True
        self.castling_rights_black_kingside = True
        self.castling_rights_black_queenside = True
        self.bitmask_en_passant = 0
        self.halfmove_clock = 0
        self.fullmove_number = 1

    # Reset all properties to 0
    fn clear(inout self):
        """
        Reset all properties to 0.
        """
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
        self.active_color = 0
        self.castling_rights_white_kingside = 0
        self.castling_rights_white_queenside = 0
        self.castling_rights_black_kingside = 0
        self.castling_rights_black_queenside = 0
        self.bitmask_en_passant = 0
        self.halfmove_clock = 0
        self.fullmove_number = 0


    # Load board FEN (only board part, i.e. up to the first space)
    fn load_fen(inout self, fen: String, allow_board_only: Bool = True) raises:
        """
        Load a FEN string into the board object.
        A complete FEN of the initial position is:
        rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1.
        It is possible to allow a board-only FEN string, with just 1 field:
        rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR.
        """
        # Reset board
        self.clear()

        # Extract FEN fields
        var fen_fields: List[String] = fen.split(" ")

        # Gross input validation
        if not allow_board_only and len(fen_fields) != 6:
            raise Error("Invalid FEN string: must contain 6 space-separated fields but has " + str(len(fen_fields)) + ".")
        if allow_board_only and len(fen_fields) != 1 and len(fen_fields) != 6:
            raise Error("Invalid FEN string: must contain 1 or 6 space-separated fields but has " + str(len(fen_fields)) + ".")

        # Try parse field 1: board FEN
        var fen_board_only: String = fen_fields[0]
        var rank: UInt64 = 7
        var file: UInt64 = 0
        var char: UInt8
        try:
            for i in range(len(fen_board_only)):
                char = UInt8(ord(fen_board_only[i]))
                if char == UInt8(ord("/")):
                    rank -= 1
                    file = 0
                else:
                    if isdigit(UInt8(char)):
                        file += UInt64(char)
                    else:
                        var piece: UInt64 = 1 << (rank * 8 + file)
                        if char == UInt8(ord("P")):
                            self.bitmask_white_pawn |= piece
                        elif char == UInt8(ord("N")):
                            self.bitmask_white_knight |= piece
                        elif char == UInt8(ord("B")):
                            self.bitmask_white_bishop |= piece
                        elif char == UInt8(ord("R")):
                            self.bitmask_white_rook |= piece
                        elif char == UInt8(ord("Q")):
                            self.bitmask_white_queen |= piece
                        elif char == UInt8(ord("K")):
                            self.bitmask_white_king |= piece
                        elif char == UInt8(ord("p")):
                            self.bitmask_black_pawn |= piece
                        elif char == UInt8(ord("n")):
                            self.bitmask_black_knight |= piece
                        elif char == UInt8(ord("b")):
                            self.bitmask_black_bishop |= piece
                        elif char == UInt8(ord("r")):
                            self.bitmask_black_rook |= piece
                        elif char == UInt8(ord("q")):
                            self.bitmask_black_queen |= piece
                        elif char == UInt8(ord("k")):
                            self.bitmask_black_king |= piece
                        else:
                            raise "Invalid piece in FEN"
                        file += 1
        except Error:
            raise Error # ("Failed to parse FEN string: invalid board field.")
        
        # Try parse the other 5 fields
        if len(fen_fields) == 6:
            # Active color
            var active_color: String = fen_fields[1]
            if active_color == "w":
                self.active_color = True
            elif active_color == "b":
                self.active_color = False
            else:
                raise Error("Failed to parse FEN string: invalid active color field.")

            # Castling rights
            var castling_rights: String = fen_fields[2]
            self.castling_rights_white_kingside = False
            self.castling_rights_white_queenside = False
            self.castling_rights_black_kingside = False
            self.castling_rights_black_queenside = False
            for i in range(len(castling_rights)):
                char = UInt8(ord(castling_rights[i]))
                if char == UInt8(ord("K")):
                    self.castling_rights_white_kingside = True
                elif char == UInt8(ord("Q")):
                    self.castling_rights_white_queenside = True
                elif char == UInt8(ord("k")):
                    self.castling_rights_black_kingside = True
                elif char == UInt8(ord("q")):
                    self.castling_rights_black_queenside = True
                elif char == UInt8(ord("-")):
                    break
                else:
                    raise Error("Failed to parse FEN string: invalid castling rights field.")
            
            # En passant square
            var en_passant: String = fen_fields[3]
            if en_passant == "-":
                self.bitmask_en_passant = 0
            else:
                if len(en_passant) != 2:
                    raise Error("Failed to parse FEN string: invalid en passant field.")
                var file: UInt64 = UInt64(ord(en_passant[0]) - ord("a"))
                var rank: UInt64 = UInt64(ord(en_passant[1]) - ord("1"))
                self.bitmask_en_passant = 1 << (rank * 8 + file)
        
            # Halfmove clock
            var halfmove_clock: String = fen_fields[4]
            try:
                self.halfmove_clock = UInt16(atol(halfmove_clock))
            except:
                raise Error("Failed to parse FEN string: invalid halfmove clock field.")

            # Fullmove number
            var fullmove_number: String = fen_fields[5]
            try:
                self.fullmove_number = UInt16(atol(fullmove_number))
            except:
                raise Error("Failed to parse FEN string: invalid fullmove number field.")

    
    # Get FEN
    fn get_fen(self, board_only: Bool = False) -> String:
        """
        Convert the board bitmasks into the full FEN string representation.
        """
        var fen: String = ""

        # Add the board part of the FEN
        for rank in range(UInt64(7), UInt64(-1), UInt64(-1)):
            var empty_count: UInt64 = 0
            for file in range(UInt64(8)):
                var piece: UInt64 = 1 << (rank * 8 + file)
                var piece_char: String = ""
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
        
        # Add the rest of the FEN fields
        if not board_only:
            # Active color
            fen += " "
            if self.active_color:
                fen += "w"
            else:
                fen += "b"
            # Castling rights
            fen += " "
            if self.castling_rights_white_kingside:
                fen += "K"
            if self.castling_rights_white_queenside:
                fen += "Q"
            if self.castling_rights_black_kingside:
                fen += "k"
            if self.castling_rights_black_queenside:
                fen += "q"
            if not self.castling_rights_white_kingside and not self.castling_rights_white_queenside and not self.castling_rights_black_kingside and not self.castling_rights_black_queenside:
                fen += "-"
            # En passant square
            fen += " "
            if self.bitmask_en_passant == 0:
                fen += "-"
            else:
                var rank: String = ""
                var file: String = ""
                for bit_position in range(64):
                    if self.bitmask_en_passant & (1 << bit_position):
                        file = chr((bit_position % 8) + ord('a'))
                        rank = str((bit_position // 8) + 1)
                fen += file + rank
            # Halfmove clock                
            fen += " "
            fen += str(self.halfmove_clock)
            # Fullmove number
            fen += " "
            fen += str(self.fullmove_number)
        return fen

    # Get bitmasks
    fn get_bitmask_white_pieces(self) -> UInt64:
        return self.bitmask_white_pawn | 
        self.bitmask_white_knight | 
        self.bitmask_white_bishop | 
        self.bitmask_white_rook | 
        self.bitmask_white_queen | 
        self.bitmask_white_king

    fn get_bitmask_black_pieces(self) -> UInt64:
        return self.bitmask_black_pawn | 
        self.bitmask_black_knight | 
        self.bitmask_black_bishop | 
        self.bitmask_black_rook | 
        self.bitmask_black_queen | 
        self.bitmask_black_king

    fn get_bitmask_all_pieces(self) -> UInt64:
        return self.get_bitmask_white_pieces() | self.get_bitmask_black_pieces()

    fn get_bitmask_empty_squares(self) -> UInt64:
        return ~self.get_bitmask_all_pieces()

    # Mirror board
    fn mirror(inout self):
        """
        Mirror the board. Swaps colors.
        """
        # Vertical flip of the bitboards
        # use byte_swap[type: DType, simd_width: Int](val: SIMD[type, simd_width]) -> SIMD[$0, $1]
        self.bitmask_white_pawn = byte_swap(self.bitmask_white_pawn)
        self.bitmask_white_knight = byte_swap(self.bitmask_white_knight)
        self.bitmask_white_bishop = byte_swap(self.bitmask_white_bishop)
        self.bitmask_white_rook = byte_swap(self.bitmask_white_rook)
        self.bitmask_white_queen = byte_swap(self.bitmask_white_queen)
        self.bitmask_white_king = byte_swap(self.bitmask_white_king)
        self.bitmask_black_pawn = byte_swap(self.bitmask_black_pawn)
        self.bitmask_black_knight = byte_swap(self.bitmask_black_knight)
        self.bitmask_black_bishop = byte_swap(self.bitmask_black_bishop)
        self.bitmask_black_rook = byte_swap(self.bitmask_black_rook)
        self.bitmask_black_queen = byte_swap(self.bitmask_black_queen)
        self.bitmask_black_king = byte_swap(self.bitmask_black_king)
        
        # Swap active color
        self.active_color = not self.active_color

        # Swap castling rights
        var temp: Bool = self.castling_rights_white_kingside
        self.castling_rights_white_kingside = self.castling_rights_black_kingside
        self.castling_rights_black_kingside = temp

        temp = self.castling_rights_white_queenside
        self.castling_rights_white_queenside = self.castling_rights_black_queenside
        self.castling_rights_black_queenside = temp

        temp = self.castling_rights_black_kingside
        self.castling_rights_black_kingside = self.castling_rights_white_kingside
        self.castling_rights_white_kingside = temp

        temp = self.castling_rights_black_queenside
        self.castling_rights_black_queenside = self.castling_rights_white_queenside
        self.castling_rights_white_queenside = temp

        # Swap en passant square
        self.bitmask_en_passant = byte_swap(self.bitmask_en_passant)
