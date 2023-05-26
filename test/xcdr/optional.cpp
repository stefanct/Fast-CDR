#include <gtest/gtest.h>

#include <array>
#include <memory>
#include <vector>

#include <fastcdr/Cdr.h>

using namespace eprosima::fastcdr;

using XCdrStreamValues =
        std::array<std::vector<char>, 0 + Cdr::EncodingAlgorithmFlag::PL_CDR2 + Cdr::Endianness::LITTLE_ENDIANNESS>;

class XCdrOptionalTest : public ::testing::TestWithParam< std::tuple<Cdr::EncodingAlgorithmFlag, Cdr::Endianness>>
{
};

TEST_P(XCdrOptionalTest, not_serialize_the_value)
{
    //{ Defining expected XCDR streams
    XCdrStreamValues expected_streams;
    expected_streams[0 + Cdr::EncodingAlgorithmFlag::PLAIN_CDR2 + Cdr::Endianness::BIG_ENDIANNESS] =
    {
        0x00, 0x06, 0x00, 0x00, // Encapsulation
        0x00 // Not present
    };
    expected_streams[0 + Cdr::EncodingAlgorithmFlag::PLAIN_CDR2 + Cdr::Endianness::LITTLE_ENDIANNESS] =
    {
        0x00, 0x07, 0x00, 0x00, // Encapsulation
        0x00 // Not present
    };
    expected_streams[0 + Cdr::EncodingAlgorithmFlag::DELIMIT_CDR2 + Cdr::Endianness::BIG_ENDIANNESS] =
    {
        0x00, 0x08, 0x00, 0x00, // Encapsulation
        0x00 // Not present
    };
    expected_streams[0 + Cdr::EncodingAlgorithmFlag::DELIMIT_CDR2 + Cdr::Endianness::LITTLE_ENDIANNESS] =
    {
        0x00, 0x09, 0x00, 0x00, // Encapsulation
        0x00 // Not present
    };
    //}

    //{ Prepare buffer
    Cdr::EncodingAlgorithmFlag encoding = std::get<0>(GetParam());
    Cdr::Endianness endianness = std::get<1>(GetParam());
    uint8_t tested_stream = 0 + encoding + endianness;
    auto buffer =
            std::unique_ptr<char, void (*)(
        void*)>{reinterpret_cast<char*>(malloc(expected_streams[tested_stream].size())), free};
    FastBuffer fast_buffer(buffer.get(), expected_streams[tested_stream].size());
    Cdr cdr(fast_buffer, endianness, Cdr::CdrType::DDS_CDR);
    //}

    //{ Encode optional not present.
    cdr.set_encoding_flag(encoding);
    cdr.serialize_encapsulation();
    Cdr::state enc_state(cdr);
    cdr.begin_serialize_member(MemberId(1), enc_state);
    cdr.end_serialize_member(enc_state);
    Cdr::state enc_state_end(cdr);
    //}

    //{ Test encoded content
    ASSERT_EQ(0, memcmp(buffer.get(), expected_streams[tested_stream].data(), expected_streams[tested_stream].size()));
    //}

    //{ Decoding optional not present
    cdr.reset();
    cdr.read_encapsulation();
    ASSERT_EQ(cdr.get_encoding_flag(), encoding);
    ASSERT_EQ(cdr.endianness(), endianness);
    Cdr::state dec_state(cdr);
    MemberId member_id;
    bool is_present = false;
    cdr.begin_deserialize_member(member_id, dec_state, is_present);
    ASSERT_FALSE(is_present);
    cdr.end_deserialize_member(dec_state);
    Cdr::state dec_state_end(cdr);
    ASSERT_EQ(enc_state_end, dec_state_end);
    //}
}

INSTANTIATE_TEST_SUITE_P(
    XCdrTest,
    XCdrOptionalTest,
    ::testing::Values(
        std::make_tuple(Cdr::EncodingAlgorithmFlag::PLAIN_CDR2, Cdr::Endianness::BIG_ENDIANNESS),
        std::make_tuple(Cdr::EncodingAlgorithmFlag::PLAIN_CDR2, Cdr::Endianness::LITTLE_ENDIANNESS),
        std::make_tuple(Cdr::EncodingAlgorithmFlag::DELIMIT_CDR2, Cdr::Endianness::BIG_ENDIANNESS),
        std::make_tuple(Cdr::EncodingAlgorithmFlag::DELIMIT_CDR2, Cdr::Endianness::LITTLE_ENDIANNESS)
        ));
