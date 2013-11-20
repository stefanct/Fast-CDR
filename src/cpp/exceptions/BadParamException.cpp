/*************************************************************************
 * Copyright (c) 2012 eProsima. All rights reserved.
 *
 * This copy of RPCDDS is licensed to you under the terms described in the
 * RPCDDS_LICENSE file included in this distribution.
 *
 *************************************************************************/

#include <fastcdr/exceptions/BadParamException.h>

namespace eprosima
{
    const std::string BadParamException::BAD_PARAM_MESSAGE_DEFAULT("Bad parameter");

	BadParamException::BadParamException(const std::string &message) : Exception(message)
	{
	}

	BadParamException::BadParamException(std::string&& message) : Exception(std::move(message))
	{
	}

	BadParamException::BadParamException(const BadParamException &ex) : Exception(ex)
	{
	}

	BadParamException::BadParamException(BadParamException&& ex) : Exception(std::move(ex))
	{
	}

	BadParamException& BadParamException::operator=(const BadParamException &ex)
	{
		if(this != &ex)
		{
			Exception::operator=(ex);
		}

		return *this;
	}

	BadParamException& BadParamException::operator=(BadParamException&& ex)
	{
		if(this != &ex)
		{
			Exception::operator=(std::move(ex));
		}

		return *this;
	}

	BadParamException::~BadParamException() throw()
	{
	}

	void BadParamException::raise() const
	{
		throw *this;
	}
} // namespace eprosima