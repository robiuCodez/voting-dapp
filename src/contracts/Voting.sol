// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// hardhat console
import "hardhat/console.sol";

contract Voting {
    // Create a Poll
    struct Poll {
        uint256 id;
        string image;
        string title;
        string description;
        uint256 totalVotes;
        uint256 totalContestants;
        bool deleted;
        address director;
        uint256 startsAt;
        uint256 endsAt;
        uint256 createdAt;
        uint256 updatedAt;
    }

    // Create a Voter
    struct Voter {
        uint256 id;
        string image;
        string fullName;
        address voterAddress; // not clear yet!.
        uint256 totalVotes;
        address[] voters;
    }

    uint256 public totalPolls;
    uint256 public totalUsers; // not clear.

    Poll[] polls;

    mapping(address => Voter) public users;
    // verify if User already voted.
    mapping(uint256 => mapping(address => bool)) public voted;

    // check if already contested for a Poll.
    mapping(uint256 => mapping(address => bool)) public contested;

    // check if it's a contestant of a Poll.
    mapping(uint256 => Voter[]) public contestantIn;

    // check if contestant exists or otherwise.
    mapping(address => bool) contestantExists;
    mapping(uint256 => bool) pollExists;

    event Voted(string fullName, address indexed voter, uint256 timestamp);

    modifier isUser() {
        require(
            users[msg.sender].voterAddress == msg.sender,
            "Not a Registered Member"
        );
        _;
    }

    function createPoll(
        string memory _image,
        string memory _title,
        string memory _description,
        uint256 _startsAt,
        uint256 _endsAt
    ) public isUser {
        require(bytes(_image).length > 0, "Image cannot be empty");
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");

        // prevent against invalid data types.
        require(_endsAt > 0 && _endsAt > _startsAt, "Invalid End Time Given");

        Poll memory poll;
        poll.id = totalPolls++;
        poll.title = _title;
        poll.description = _description;
        poll.image = _image;
        poll.startsAt = _startsAt;
        poll.endsAt = _endsAt;
        poll.director = msg.sender;
        poll.createdAt = block.timestamp;

        polls.push(poll);
        pollExists[poll.id] = true;
    }

    modifier pollExist(uint256 _pollId) {
        require(pollExists[_pollId], "Poll does not exist");
        _;
    }

    // verify if post is not deleted.
    modifier isNotDeleted(uint256 _pollId) {
        require(polls[_pollId].deleted != true, "Poll no longer exists");
        _;
    }

    function updatePollById(
        uint256 _pollId,
        string memory _image,
        string memory _title,
        string memory _description,
        uint256 _startsAt,
        uint256 _endsAt
    ) public isUser pollExist(_pollId) isNotDeleted(_pollId) {
        require(bytes(_image).length > 0, "Image cannot be empty");
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");

        // prevent against invalid data types.
        require(_endsAt > 0 && _endsAt > _startsAt, "Invalid End Time Given");

        polls[_pollId].title = _title;
        polls[_pollId].description = _description;
        polls[_pollId].image = _image;
        polls[_pollId].startsAt = _startsAt;
        polls[_pollId].endsAt = _endsAt;
        polls[_pollId].updatedAt = block.timestamp;
    }

    modifier isAuthor(address _author) {
        require(_author == msg.sender, "Unauthorized Action");
        _;
    }

    function deletePollById(uint256 _pollId)
        public
        isAuthor(polls[_pollId].director)
        pollExist(_pollId)
    {
        // set the poll deleted status to true.
        polls[_pollId].deleted = true;
    }

    function getPollById(uint256 _pollId)
        public
        view
        pollExist(_pollId)
        returns (Poll memory)
    {
        return polls[_pollId];
    }

    function getAllPolls() public view returns (Poll[] memory) {
        return polls;
    }

    function registerUser(string memory _image, string memory _fullName)
        public
    {
        Voter memory user;

        // fill the registration form fields.
        user.id = totalUsers++;
        user.image = _image;
        user.fullName = _fullName;
        user.voterAddress = msg.sender;

        // register user.
        users[msg.sender] = user;
    }

    // check if user is already contestign for a poll.
    modifier alreadyContested() {
        require(contestantExists[msg.sender], "Already Contested");
        _;
    }

    function contest(uint256 _id) public pollExist(_id) alreadyContested {
        // Create a Voter struct, as user === voter.
        Voter memory user = users[msg.sender];

        if (!contestantExists[msg.sender]) {
            contestantIn[_id].push(user);
            contested[_id][msg.sender] = true;

            // add contestants to the poll
            polls[_id].totalContestants++;
        }
    }

    function getAllContestantsByPoll(uint256 _pollId)
        public
        view
        pollExist(_pollId)
        returns (Voter[] memory)
    {
        return contestantIn[_pollId];
    }

    // verify user has not voted already.
    // to curb against double-voting
    modifier notVotedAlready(uint256 _pollId, address _voter) {
        require(!voted[_pollId][_voter], "Already Voted");
        _;
    }

    // verify poll has not been deleted already
    modifier pollNotDeleted(uint256 _pollId) {
        require(!polls[_pollId].deleted, "Poll has been deleted");
        _;
    }

    modifier pollInSession(uint256 _pollId) {
        require(
            block.timestamp > polls[_pollId].startsAt &&
                polls[_pollId].endsAt > block.timestamp,
            "Poll not in session"
        );
        _;
    }

    function voteContestant(uint256 _pollId, uint256 _contestantId)
        public
        isUser
        pollExist(_pollId)
        notVotedAlready(_pollId, msg.sender)
        pollNotDeleted(_pollId)
        pollInSession(_pollId)
    {
        polls[_pollId].totalVotes++;
        contestantIn[_pollId][_contestantId].totalVotes++;
        contestantIn[_pollId][_contestantId].voters.push(msg.sender);

        // prevent double-voting.
        voted[_pollId][msg.sender] = true;
    }
}
