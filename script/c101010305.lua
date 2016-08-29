--Action Field - Crystal Cavern
function c101010305.initial_effect(c)
--Activate  
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,101010321+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0xff)
	e1:SetOperation(c101010305.op)
	c:RegisterEffect(e1)
	--unaffectable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c101010305.ctcon2)
	c:RegisterEffect(e3)
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c101010305.aclimit2)
	c:RegisterEffect(e4)
	local e8=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c101010305.aclimit2)
	c:RegisterEffect(e8)
	--~ Add Action Card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(95000043,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(c101010305.condition)
	e5:SetTarget(c101010305.Acttarget)
	e5:SetOperation(c101010305.operation)
	c:RegisterEffect(e5)
	--cannot change zone
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetCode(EFFECT_CANNOT_TO_DECK)
	eb:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	eb:SetRange(LOCATION_SZONE)
	c:RegisterEffect(eb)
	local ec=eb:Clone()
	ec:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(ec)
	local ed=eb:Clone()
	ed:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(ed)
	local ee=eb:Clone()
	ee:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(ee)
	--cheater check
	local ef=Effect.CreateEffect(c) 
	ef:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ef:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ef:SetCode(EVENT_PREDRAW)
	ef:SetCountLimit(1)
	ef:SetRange(0xff)
	ef:SetOperation(c101010305.Cheatercheck1)
	c:RegisterEffect(ef)
	-- Draw when removed
	local ef3=Effect.CreateEffect(c)
	ef3:SetDescription(aux.Stringid(44792253,0))
	ef3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ef3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ef3:SetCode(EVENT_REMOVE)
	ef3:SetCondition(c101010305.descon)
	ef3:SetTarget(c101010305.drtarget)
	ef3:SetOperation(c101010305.drop)
	c:RegisterEffect(ef3)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_SZONE,0)
	e6:SetTarget(c101010305.pendulum)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(101010305,0))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,101010305)
	e7:SetTarget(c101010305.thtg)
	e7:SetOperation(c101010305.thop)
	c:RegisterEffect(e7)
end
function c101010305.Cheatercheck1(e,c)
	if Duel.GetMatchingGroupCount(c101010305.Fieldfilter,tp,0,LOCATION_DECK+LOCATION_HAND,nil)>1
		then
		local WIN_REASON_ACTION_FIELD=0x55
		Duel.Win(tp,WIN_REASON_ACTION_FIELD)
	end
	local sg=Duel.GetMatchingGroup(c101010305.Fieldfilter,tp,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c101010305.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c101010305.drtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101010305.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_RULE)
end
function c101010305.Fieldfilter(c)
	return c:IsSetCard(0xac2)
end
function c101010305.ctcon2(e,re)
	return re:GetHandler()~=e:GetHandler()
end
function c101010305.aclimit2(e,c)
	return c:IsType(TYPE_FIELD)
end
function c101010305.tgn(e,c)
	return c==e:GetHandler()
end
function c101010305.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)  
	if tc==nil then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if tc2==nil then
			local token=Duel.CreateToken(tp,101010305,nil,nil,nil,nil,nil,nil)  
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			token:RegisterEffect(e1)
			Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		end
	end
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
-- Add Action Card
function c101010305.Acttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=0
		and Duel.GetFlagEffect(tp,95000043)==0 then
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst():GetCode()
		math.randomseed(tc)
	end
	i = math.random(20)
	ac=math.random(1,tableAction_size)
	if tableAction[ac]==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,95000043,RESET_EVENT+EVENT_TO_HAND+RESET_EVENT+EVENT_TO_GRAVE+RESET_EVENT+EVENT_TO_DECK+RESET_EVENT+EVENT_REMOVE+RESET_EVENT+EVENT_SPSUMMON,0,1)
	end
	e:SetLabel(tableAction[ac])
end
function c101010305.spfilter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010305.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1613)
end
function c101010305.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(95000043,0)) then
		local dc=Duel.TossDice(tp,1)
		if dc==2 or dc==3 or dc==4 or dc==6 then
			e:GetHandler():RegisterFlagEffect(101010305,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		if dc==1 or dc==2 then
			if not Duel.IsExistingMatchingCard(c101010305.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) then
				--- check action Trap
				if e:GetLabel()==101010321 or e:GetLabel()==101010321 then
					local token=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)   
					Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fc0000)
					e1:SetValue(TYPE_TRAP)
					token:RegisterEffect(e1)
					Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					Duel.SpecialSummonComplete()
					if (e:GetLabel()==101010321 and not Duel.IsExistingTarget(c101010305.atkfilter,tp,LOCATION_MZONE,0,1,nil)) or (e:GetLabel()==101010321 and not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101010305.spfilter,tp,LOCATION_DECK,LOCATION_DECK,1,nil,e,tp))) then Duel.SendtoGrave(token,nil,REASON_RULE) end
					local tc=token
					local te=tc:GetActivateEffect()
					local tep=tc:GetControler()
					local condition=te:GetCondition()
					local cost=te:GetCost()
					local target=te:GetTarget()
					local operation=te:GetOperation()
					if (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
						and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
						and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
						Duel.ClearTargetCard()
						e:SetProperty(te:GetProperty())
						Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
						tc:CreateEffectRelation(te)
						if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
						if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
						local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
						if g then
							local tg=g:GetFirst()
							while tg do
								tg:CreateEffectRelation(te)
								tg=g:GetNext()
							end
						end
						if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
						tc:ReleaseEffectRelation(te)
						if g then
							tg=g:GetFirst()
							while tg do
								tg:ReleaseEffectRelation(te)
								tg=g:GetNext()
							end
						end
					end
					Duel.SendtoGrave(tc,REASON_RULE)
				else
					local token=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)   
					Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fc0000)
					e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
					token:RegisterEffect(e1)
					Duel.SendtoHand(token,nil,REASON_EFFECT)
					Duel.SpecialSummonComplete()	
				end
			end
		end
		if dc==5 or dc==6 then
			if not Duel.IsExistingMatchingCard(c101010305.cfilter,1-tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) then
				--- check action Trap
				if e:GetLabel()==101010321 or e:GetLabel()==101010321 then
					local token=Duel.CreateToken(1-tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)   
					Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fc0000)
					e1:SetValue(TYPE_TRAP)
					token:RegisterEffect(e1)
					Duel.MoveToField(token,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
					Duel.SpecialSummonComplete()
					if (e:GetLabel()==101010321 and not Duel.IsExistingTarget(c101010305.atkfilter,1-tp,LOCATION_MZONE,0,1,nil)) or (e:GetLabel()==101010321 and not (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101010305.spfilter,tp,LOCATION_DECK,LOCATION_DECK,1,nil,e,1-tp))) then Duel.SendtoGrave(token,nil,REASON_RULE) end
					local tc=token
					local te=tc:GetActivateEffect()
					local tep=tc:GetControler()
					local condition=te:GetCondition()
					local cost=te:GetCost()
					local target=te:GetTarget()
					local operation=te:GetOperation()
					if (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
						and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
						and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
						Duel.ClearTargetCard()
						e:SetProperty(te:GetProperty())
						Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
						tc:CreateEffectRelation(te)
						if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
						if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
						local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
						if g then
							local tg=g:GetFirst()
							while tg do
								tg:CreateEffectRelation(te)
								tg=g:GetNext()
							end
						end
						if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
						tc:ReleaseEffectRelation(te)
						if g then
							tg=g:GetFirst()
							while tg do
								tg:ReleaseEffectRelation(te)
								tg=g:GetNext()
							end
						end
					end
					Duel.SendtoGrave(tc,REASON_RULE)
				else
					local token=Duel.CreateToken(1-tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)  
					Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fc0000)
					e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
					token:RegisterEffect(e1)
					Duel.SendtoHand(token,1-tp,REASON_EFFECT)
					Duel.SpecialSummonComplete()
				end
			end
		end
	else 
		if not Duel.IsExistingMatchingCard(c101010305.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) then
			--- check action Trap
			if e:GetLabel()==101010321 or e:GetLabel()==101010321 then
				local token=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)   
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fc0000)
				e1:SetValue(TYPE_TRAP)
				token:RegisterEffect(e1)
				Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				Duel.SpecialSummonComplete()
				if (e:GetLabel()==101010321 and not Duel.IsExistingTarget(c101010305.atkfilter,tp,LOCATION_MZONE,0,1,nil)) or (e:GetLabel()==101010321 and not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101010305.spfilter,tp,LOCATION_DECK,LOCATION_DECK,1,nil,e,tp))) then Duel.SendtoGrave(token,nil,REASON_RULE) end
				local tc=token
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local condition=te:GetCondition()
				local cost=te:GetCost()
				local target=te:GetTarget()
				local operation=te:GetOperation()
				if (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
					and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
					and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
					Duel.ClearTargetCard()
					e:SetProperty(te:GetProperty())
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					tc:CreateEffectRelation(te)
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
					local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if g then
						local tg=g:GetFirst()
						while tg do
							tg:CreateEffectRelation(te)
							tg=g:GetNext()
						end
					end
					if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
					tc:ReleaseEffectRelation(te)
					if g then
						tg=g:GetFirst()
						while tg do
							tg:ReleaseEffectRelation(te)
							tg=g:GetNext()
						end
					end
				end
				Duel.SendtoGrave(tc,REASON_RULE)
			else
				local token=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)   
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fc0000)
				e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
				token:RegisterEffect(e1)
				Duel.SendtoHand(token,nil,REASON_EFFECT)
				Duel.SpecialSummonComplete()	
			end
		end
	end
end
function c101010305.aclimit2(e,c)
	return c:IsType(TYPE_FIELD)
end
function c101010305.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101010305.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(101010305)==0 and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c101010305.cfilter(c)
	return c:IsSetCard(0xac1)
end
tableAction = {
95000044,
95000099,
95000131,
95000132,
95000143,
95000145,
101010306,
101010321,
101010322,
101010306,
101010321,
101010322
} 
tableAction_size=12
function c101010305.pendulum(e,c)
	local seq=c:GetSequence()
	return seq==7 or seq==6
end
function c101010305.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1613) and c:IsDestructable()
end
function c101010305.thfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101010305.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010305.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101010305.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c101010305.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010305.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010305.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c101010305.thfilter,tp,LOCATION_DECK,0,nil)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
