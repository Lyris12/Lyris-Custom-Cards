--Starry-Eyes Stripe Dragon
function c101010366.initial_effect(c)
	--If this face-up card would be banished, return it to the Extra Deck instead.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_SEND_REPLACE)
	e0:SetTarget(c101010366.reptg)
	c:RegisterEffect(e0)
	--You can dispose 1 of this card's Points, then target 1 banished monster; shuffle that target into the Deck, then all monsters your opponent controls lose ATK and DEF equal to its ATK or DEF in the Deck (whichever is higher).
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCost(c101010366.cost)
	e1:SetTarget(c101010366.target)
	e1:SetOperation(c101010366.operation)
	c:RegisterEffect(e1)
	if not c101010366.global_check then
		c101010366.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(500)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010366.chk)
		Duel.RegisterEffect(ge2,0)
	end
	if not relay_check then
		relay_check=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetCountLimit(1)
		ge3:SetLabel(481)
		ge3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge3:SetOperation(c101010366.chk)
		Duel.RegisterEffect(ge3,0)
	end
end
c101010366.spatial=true
--Spatial Formula filter(s)
c101010366.alterf=  function(mc)
						return mc.spatial or (mc.relay and mc:GetLevel()==7)
					end
c101010366.alterop= function(e,tp,chk)
						local rc=e:GetLabelObject()
						if chk==0 then return rc:IsExists(c101010366.alfilter,1,nil,rc) end
						local mc=Duel.SelectMatchingCard(tp,c101010366.altfilter,tp,LOCATION_MZONE,0,1,1,rc:GetFirst(),rc:GetFirst())
						return mc:GetFirst()
					end
c101010366.relay=true
c101010366.point=1
function c101010366.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c101010366.alfilter(c,g)
	return c:IsFaceup() and c101010366.alterf(c) and c:IsAbleToRemove() and g:IsExists(c101010366.altfilter,1,c,c)
end
function c101010366.altfilter(c,tc)
	return c:IsFaceup() and ((not tc.relay and (c.relay and c:GetLevel()==7)) or (not tc.spatial and c.spatial)) and c:IsAbleToRemove()
end
function c101010366.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsOnField() and c:GetDestination()==LOCATION_REMOVED end
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
		return true
	else return false end
end
function c101010366.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
end
function c101010366.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101010366.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c101010366.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010366.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101010366.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101010366.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)
		and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local atk=tc:GetAttack()
		local c=e:GetHandler()
		local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local oc=tg:GetFirst()
		if atk>0 and oc then
			Duel.BreakEffect()
			while oc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-atk)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				oc:RegisterEffect(e1)
				oc=tg:GetNext()
			end
		end
	end
end
