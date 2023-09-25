// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TicketBooking {
    uint256 passengerCount = 0;
    uint256 idCount = 0;
    mapping(address => uint256[]) public passengerToSeats; 
    mapping(uint => address) public passengerIds;
    mapping(address=>uint) public bookingCountPerPassenger;

    //To book seats
    function bookSeats(uint[] memory seatNumbers) public {
        require(seatNumbers.length !=0 && seatNumbers.length <=4 && bookingCountPerPassenger[msg.sender] + seatNumbers.length <= 4);
        for(uint256 i = 0; i < seatNumbers.length; i++){
            require(seatNumbers[i]>0 && seatNumbers[i]<=20,"Transaction failed");
        }
        passengerCount++;
        passengerIds[idCount] = msg.sender;
        for(uint i = 0; i < seatNumbers.length; i++){
           require(checkAvailability(seatNumbers[i]), "Seat not available");
           for (uint j = i + 1; j < seatNumbers.length; j++) {
                require(seatNumbers[i] != seatNumbers[j], "Duplicate seats");
            }
            passengerToSeats[msg.sender].push(seatNumbers[i]);
            bookingCountPerPassenger[msg.sender] += 1;
        }
        idCount++;
    }
    
    //To get available seats
    function showAvailableSeats() public view  returns (uint[] memory) {
       uint256[] memory availableSeats = new uint256[](20);
       uint256 count =0;    
        for(uint i = 1; i <= 20; i++){
        if(checkAvailability(i)){
            availableSeats[count] = i;
            count++;
        }
        }

        uint256[] memory trimmedSeatArray = new uint256[](count);
        for(uint j = 0; j  < count; j++){
            trimmedSeatArray[j] = availableSeats[j];
        }
    
        return trimmedSeatArray;
    }
    
    //To check availability of a seat
    function checkAvailability(uint seatNumber) public view returns (bool) {
        require(seatNumber>0 && seatNumber <=20);
        for(uint i = 0 ; i < passengerCount; i++){
            address addressId = passengerIds[i];
            uint[] memory bookedSeats = passengerToSeats[addressId];
            for(uint j = 0 ; j < bookedSeats.length; j++){
                if(seatNumber==bookedSeats[j]){
                    return false;
                }
            }
        }
        return true;
    }
    
    //To check tickets booked by the user
    function myTickets() public view returns (uint[] memory) {
        uint256[] memory emptyArray;
        if(passengerToSeats[msg.sender].length==0){
            return emptyArray;
        }
        return passengerToSeats[msg.sender];
    }
}
