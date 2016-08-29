--If the difference between a monster's ATK and original (printed) ATK is more than 2500, that monster is destroyed. Negate the effects of FIRE monsters on the field.
function c101010065.initial_effect(c)
--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c101010065.disable)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetRange(LOCATION_FZONE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(c101010065.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_ADJUST)
	c:RegisterEffect(e2)
end
function c101010065.desfilter(c)
	local atk=c:GetAttack()
	local def=c:GetDefense()
	return atk<=0 or def<=0 or math.abs(atk-def)>2500
end
function c101010065.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if c101010065.desfilter(tc) then
				local catk=tc:GetAttack()
				local cdef=c:GetDefense()
				if catk~=0 and cdef~=0 then
					if Duel.Destroy(tc,REASON_EFFECT)==0 then
						if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then
							Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
						end
					end
				else
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
			tc=g:GetNext()
		end
	end
end
function c101010065.disable(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
end
