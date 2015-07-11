/*************************************************************************
 * Copyright (c) 2013 eProsima. All rights reserved.
 *
 * This copy of FastCdr is licensed to you under the terms described in the
 * FASTCDR_LIBRARY_LICENSE file included in this distribution.
 *
 *************************************************************************/

#include <exceptions/Exception.h>

using namespace eprosima::fastcdr::exception;

Exception::Exception(const char* const &message) : m_message(message)
{
}

Exception::Exception(const Exception &ex) : m_message(ex.m_message)
{
}

#if HAVE_STDCXX_0X
Exception::Exception(Exception&& ex) : m_message(std::move(ex.m_message))
{
}
#endif

Exception& Exception::operator=(const Exception &ex)
{
    m_message = ex.m_message;
    return *this;
}

#if HAVE_STDCXX_0X
Exception& Exception::operator=(Exception&&)
{
    m_message = std::move(m_message);
    return *this;
}
#endif

Exception::~Exception() throw()
{
}

const char* Exception::what() const throw()
{
    return m_message.c_str();
}
