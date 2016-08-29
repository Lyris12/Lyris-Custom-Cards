--PSYStream Barrierreef
function c101010129.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--If a "PSYStream" card(s) you control would destroyed by battle or card effect, you can send "PSYStream" cards from your Deck to the Graveyard, up to the number of "PSYStream" cards that would be destroyed, instead of destroying an equal amount of those cards.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c101010129.reptg)
	e4:SetOperation(c101010129.repop)
	e4:SetValue(c101010129.repval)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c101010129.tgop)
	c:RegisterEffect(e2)
end
function c101010129.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField()
		and c:IsSetCard(0x127) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c101010129.cfilter(c)
	return c:IsSetCard(0x127) and c:IsAbleToGrave()
end
function c101010129.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local pg=eg:Filter(c101010129.repfilter,nil,tp)
	if chk==0 then return pg:GetCount()>0 and Duel.IsExistingMatchingCard(c101010129.cfilter,tp,LOCATION_DECK,0,1,nil) and not pg:IsContains(e:GetHandler()) end
	if Duel.SelectYesNo(tp,aux.Stringid(101010129,0)) then
		local ct=pg:GetCount()
		local rg=Duel.SelectMatchingCard(tp,c101010129.cfilter,tp,LOCATION_DECK,0,1,ct,nil)
		local pt=Duel.SendtoGrave(rg,REASON_EFFECT)
		if ct==pt then
			pg:KeepAlive()
			e:SetLabelObject(pg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=pg:Select(tp,1,pt,nil)
			Duel.HintSelection(cg)
			cg:KeepAlive()
			e:SetLabelObject(cg)
		end
		return true
	else return false end
end
function c101010129.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function c101010129.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) and c:GetReasonEffect():IsSetCard(0x127) then
		--Each time the effect of a banished "PSYStream" monster is activated while this card is in your Graveyard, except during the turn this card was sent to the Graveyard, inflict 500 damage to your opponent.
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c101010129.regop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetRange(LOCATION_REMOVED)
		e3:SetCondition(c101010129.damcon)
		e3:SetOperation(c101010129.damop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
	end
end
function c101010129.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101010129,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c101010129.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
	return aux.exccon(e) and c:GetFlagEffect(101010129)~=0 and loc==LOCATION_REMOVED and ex:GetHandler():IsSetCard(0x127) and ex:IsType(TYPE_MONSTER)
end
function c101010129.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101010129)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
